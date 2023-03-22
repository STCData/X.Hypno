//
//  VADummyAssistant.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Foundation

struct VADummyAssistant: VAAssistant {
    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage] {
        let userMessage = VAMessage(text: message, role: .user)
        let assistantResponce = VAMessage(text: "bot said: '\(message)'", role: .assistant)
        return chat + [userMessage, assistantResponce]
    }
}
