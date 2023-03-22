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
        let assistantResponce = VAMessage(text: "you said: '\(message)', im just dummy echo bot.", role: .assistant)
        return chat + [userMessage, assistantResponce]
    }
}
