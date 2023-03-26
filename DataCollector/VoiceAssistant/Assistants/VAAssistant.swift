//
//  VAAssistant.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Combine
import Foundation

protocol VAAssistant {
    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage]

    var assistantCodeSubject: AnyPublisher<String, Never>? { get }
    var assistantGUIAutomateSubject: AnyPublisher<String, Never>? { get }
    var assistantBrowserAutomateSubject: AnyPublisher<String, Never>? { get }
    var assistantBashCodeSubject: AnyPublisher<String, Never>? { get }
}

func VAAssistantShared() -> VAAssistant {
    return VADoubleTapOpenAIAssistant.shared
//    return VAOpenAIAssistant.shared
//    return VADummyAssistant.shared
}
