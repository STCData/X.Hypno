//
//  VAOpenAIAssistant.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Combine
import Foundation
import OpenAISwift

class VAOpenAIAssistant: VAAssistant {
    private let openAIAuthToken: String
    private var openAI: OpenAISwift

    private let systemMessage: String

    internal init(systemMessage: String) throws {
        self.systemMessage = systemMessage
        guard let path = Bundle.main.path(forResource: "SECRET", ofType: "plist") else {
            throw NSError(domain: "BundleError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find path to SECRET.plist"])
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw NSError(domain: "PlistError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't read contents of SECRET.plist"])
        }

        guard let token = dict["OpenAIAuthToken"] as? String else {
            throw NSError(domain: "TokenError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find OpenAIAuthToken field in SECRET.plist"])
        }

        openAIAuthToken = token
        openAI = OpenAISwift(authToken: openAIAuthToken)
    }

    var assistantCodeSubject: AnyPublisher<String, Never>? {
        return passthroughCodeSubject.eraseToAnyPublisher()
    }

    var assistantGUIAutomateSubject: AnyPublisher<String, Never>? = nil

    var assistantBrowserAutomateSubject: AnyPublisher<String, Never>? = nil

    var assistantBashCodeSubject: AnyPublisher<String, Never>? = nil

    let passthroughCodeSubject = PassthroughSubject<String, Never>()

    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage] {
        let userMessage = VAMessage(text: message, role: .user)

        let openAIMessages = openAIMessages(with: chat + [userMessage])

        var responseMessages = [VAMessage]()

        var openAIResponseMessage: ChatMessage? = nil
        do {
            let openAIResponse = try await openAI.sendChat(with: openAIMessages)
            openAIResponseMessage = openAIResponse.choices.first?.message
            if let openAIResponseMessage {
                responseMessages = VAMessage.from(openAIMessage: openAIResponseMessage)
            } else {
                responseMessages = [VAMessage(text: "no message received from openai", role: .error)]
            }

        } catch {
            responseMessages = [VAMessage(text: "error communicating to openai", role: .error)]
        }

        for m in responseMessages {
            if m.role == .assistantCode {
                passthroughCodeSubject.send(m.text)
                print(m.text)
                break // send only one code per response
            }
        }

        return chat + [userMessage] + responseMessages
    }

    func openAIMessages(with messages: [VAMessage]) -> [ChatMessage] {
        return messages.openAIMessages(systemChatMessage: ChatMessage(role: .system, content: systemMessage))
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
            }
        }
    }
}
