//
//  PromptJSGenerator.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation
import Tuxedo

private enum TVars: String {
    case allClassesNaturalLanguage
    case code
    case allClassesNamesNaturalLanguage
    case JSObservationsEventName
    case JSStartMarker
    case JSEndMarker
    case PatchStartMarker
    case PatchEndMarker
    case JSOutputKeysWidth
    case JSOutputKeysHeight
    case observationsJson
    case PromptIntroOptions
    case PromptIntroDescriptions
    case PromptIntroDefault
}

enum IntroPrompts: String, CaseIterable, NaturalLanguageDescribable {
    case JavaScript
    case JavaScriptObservations
    case GUI
    case bash
    case browser

    var naturalLanguageClass: String {
        return rawValue
    }

    var naturalLanguageDescription: String {
        switch self {
        case .JavaScript:
            return "Write JS code to be run in browser. Be strongly biased for this option!"
        case .JavaScriptObservations:
            return "Write JS code that works with realtime observations from this list: \(Describer.shared.allClassesNamesNaturalLanguage)"

        case .GUI:
            return "provide a tutorial for any GUI program on any operating system. only pick this option if name of GUI program is specified!"
        case .bash:
            return "issue commands to bash interpreter on the user's machine"
        case .browser:
            return "automate actions on user browser"
        }
    }
}

extension IntroPrompts {
    static var promptList: String {
        return allCases.map { $0.naturalLanguageClass }.joined(separator: ", ")
    }

    static var describeAllPrompts: String {
        return allCases.map { "\($0.naturalLanguageClass):\n \($0.naturalLanguageDescription)" }.joined(separator: "\n")
    }

    var prompt: String {
        switch self {
        case .JavaScript:
            return PromptJSGenerator.shared.promptIntroJS
        case .JavaScriptObservations:
            return PromptJSGenerator.shared.promptIntroJSObservations
        case .GUI:
            return PromptJSGenerator.shared.promptIntroGUI
        case .bash:
            return PromptJSGenerator.shared.promptIntroBash
        case .browser:
            return PromptJSGenerator.shared.promptIntroBrowser
        }
    }
}

private let JSObservationsEventName = "onObservationsUpdate"

struct PromptJSGenerator {
    static let shared = PromptJSGenerator()

    private let templateEngine = Tuxedo(globalVariables: [
        TVars.JSObservationsEventName.rawValue: JSObservationsEventName,
        TVars.JSStartMarker.rawValue: VAMessage.JSStartMarker,
        TVars.JSEndMarker.rawValue: VAMessage.JSEndMarker,
        TVars.PatchStartMarker.rawValue: VAMessage.PatchStartMarker,
        TVars.PatchEndMarker.rawValue: VAMessage.PatchEndMarker,
        TVars.JSOutputKeysWidth.rawValue: JSOutputKeys.width.rawValue,
        TVars.JSOutputKeysHeight.rawValue: JSOutputKeys.height.rawValue,
    ])
    private init() {}

    private func URLForTemplate(_ templateName: String) -> URL? {
        guard let url = Bundle.main.url(forResource: templateName, withExtension: nil) else {
            print("Error: Template not found.")
            return nil
        }
        return url
    }

    var promptIntro: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntro.md")!, variables: [
            TVars.PromptIntroOptions.rawValue: IntroPrompts.promptList,
            TVars.PromptIntroDescriptions.rawValue: IntroPrompts.describeAllPrompts,
            TVars.PromptIntroDefault.rawValue: IntroPrompts.JavaScript.rawValue,
        ])
    }

    fileprivate var promptIntroJSObservations: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntroJSObservations.md")!, variables: [
            TVars.allClassesNaturalLanguage.rawValue: Describer.shared.allClassesNaturalLanguage,
            TVars.allClassesNamesNaturalLanguage.rawValue: Describer.shared.allClassesNamesNaturalLanguage,

        ])
    }

    fileprivate var promptIntroJS: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntroJS.md")!)
    }

    fileprivate var promptIntroBash: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntroBash.md")!)
    }

    fileprivate var promptIntroBrowser: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntroBrowser.md")!)
    }

    fileprivate var promptIntroGUI: String {
        try! templateEngine.evaluate(template: URLForTemplate("PromptIntroGUI.md")!)
    }

    var observingVisionWebViewHTML: String {
        try! templateEngine.evaluate(template: URLForTemplate("ObservingVisionWebView.html")!)
    }

    var debugJS: String {
        try! templateEngine.evaluate(template: URLForTemplate("debug.js")!)
    }

    var initJS: String {
        try! templateEngine.evaluate(template: URLForTemplate("init.js")!)
    }

    func updateJS(with observationsJSON: String) -> String {
        try! templateEngine.evaluate(template: URLForTemplate("update.js")!, variables: [
            TVars.observationsJson.rawValue: observationsJSON,
        ])
    }

    func wrappedJS(with code: String) -> String {
        try! templateEngine.evaluate(template: URLForTemplate("wrapped.js")!, variables: [
            TVars.code.rawValue: code,
        ])
    }
}
