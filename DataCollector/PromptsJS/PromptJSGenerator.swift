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
    case JSOutputKeysWidth
    case JSOutputKeysHeight
    case observationsJson
}

private let JSObservationsEventName = "onObservationsUpdate"

struct PromptJSGenerator {
    static let shared = PromptJSGenerator()

    private let templateEngine = Tuxedo(globalVariables: [
        TVars.JSObservationsEventName.rawValue: JSObservationsEventName,
        TVars.JSStartMarker.rawValue: VAMessage.JSStartMarker,
        TVars.JSEndMarker.rawValue: VAMessage.JSEndMarker,
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
            TVars.allClassesNaturalLanguage.rawValue: Describer.shared.allClassesNaturalLanguage,
            TVars.allClassesNamesNaturalLanguage.rawValue: Describer.shared.allClassesNamesNaturalLanguage,

        ])
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
