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
    case allClassesNamesNaturalLanguage
    case JSObservationsEventName
    case JSStartMarker
    case JSEndMarker
}

private let JSObservationsEventName = "onObservationsUpdate"

struct PromptJSGenerator {
    static let shared = PromptJSGenerator()

    private let templateEngine = Tuxedo(globalVariables: [
        TVars.JSObservationsEventName.rawValue: JSObservationsEventName,
        TVars.JSStartMarker.rawValue: VAMessage.JSStartMarker,
        TVars.JSEndMarker.rawValue: VAMessage.JSEndMarker,
    ])
    private init() {}
}
