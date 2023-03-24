//
//  VAMessage+OpenAI.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation
import OpenAISwift

extension VAMessage {
    static let JSStartMarker = "%%JSBE"
    static let JSEndMarker = "%%JSEND"

    static func from(openAIMessage: ChatMessage) -> [VAMessage] {
        switch openAIMessage.role {
        case .system:
            fatalError("wrong usage")
        case .user:
            return [VAMessage(text: openAIMessage.content, role: .user)]
        case .assistant:
            return parseAssistantMessages(from: openAIMessage.content)
        }
    }

    private static func isEmpty(_ text: String) -> Bool {
        let strippedText = text.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
        return strippedText.count == 0
    }

    static func parseAssistantMessages(from string: String) -> [VAMessage] {
        var messages = [VAMessage]()

        // Split the string into lines
        let lines = string.split(separator: "\n")

        // Loop through the lines and look for text blocks marked by markers
        var role: VAMessageRole = .assistant
        var text = ""
        for line in lines {
            if line.hasPrefix(VAMessage.JSStartMarker) {
                // Start of code block
                if !isEmpty(text) {
                    messages.append(VAMessage(text: text, role: role))
                }
                role = .assistantCode
                text = ""
            } else if line.hasPrefix(VAMessage.JSEndMarker) {
                // End of code block
                messages.append(VAMessage(text: text, role: .assistantCode))
                role = .assistant
                text = ""
            } else {
                if !line.hasPrefix("```") {
                    text += line + "\n"
                }
            }
        }

        // Append the last message
        if !isEmpty(text) {
            messages.append(VAMessage(text: text, role: role))
        }

        return messages
    }
}
