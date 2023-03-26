//
//  Array+VAMessage.swift
//  DataCollector
//
//  Created by standard on 3/27/23.
//

import Foundation
import OpenAISwift

extension Array where Element == VAMessage {
    var firstUserMessageText: String? {
        for message in self {
            if message.role == .user {
                return message.text
            }
        }
        return nil
    }
}

extension Array where Element == VAMessage {
    func openAIMessages(systemChatMessage: ChatMessage) -> [ChatMessage] {
        return [systemChatMessage] + compactMap { message in
            switch message.role {
            case .assistant:
                return ChatMessage(role: .assistant, content: message.text)
            case .assistantCode:
                return ChatMessage(role: .assistant, content: "```\n\(message.text)\n```\n")

            case .user:
                return ChatMessage(role: .user, content: message.text)
            case .userExpectingResponse:
                fatalError("userExpectingResponse should not be passed to openai")

            case .userRecordingInProcess:
                fatalError("userRecordingInProcess should not be passed to openai")
            case .userTyping:
                fatalError("userTyping should not be passed to openai")
            case .error:
                return nil
            case .assistantClientSideService:
                return nil
            }
        }
    }
}
