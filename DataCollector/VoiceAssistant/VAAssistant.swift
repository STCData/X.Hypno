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

    var assistantCodeSubject: AnyPublisher<String, Never> { get }
}

func VAAssistantShared() -> VAAssistant {
    return VADummyAssistant.shared
}
