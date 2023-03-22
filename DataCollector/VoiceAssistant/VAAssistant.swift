//
//  VAAssistant.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Foundation

protocol VAAssistant {
    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage]
}
