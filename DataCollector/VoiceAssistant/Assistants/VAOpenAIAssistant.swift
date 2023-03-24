//
//  VAOpenAIAssistant.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Combine
import Foundation
import OpenAISwift

struct VAOpenAIAssistant: VAAssistant {
    static let shared = try! VAOpenAIAssistant()

    private let openAIAuthToken: String
    private var openAI: OpenAISwift

    private init() throws {
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

    var assistantCodeSubject: AnyPublisher<String, Never> {
        return passthroughCodeSubject.eraseToAnyPublisher()
    }

    let passthroughCodeSubject = PassthroughSubject<String, Never>()

    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage] {
        let userMessage = VAMessage(text: message, role: .user)

//        if assistantResponce.role == .assistantCode {
//            passthroughCodeSubject.send(assistantResponce.text)
//        }
//
//        return chat + [userMessage, assistantResponce]

        let openAIMessages = openAIMessages(with: chat + [userMessage])

        var responseMessages = [VAMessage]()
        do {
            let openAIResponse = try await openAI.sendChat(with: openAIMessages)
            if let openAIResponseMessage = openAIResponse.choices.first?.message {
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
                break // send only one code per response
            }
        }

        return chat + [userMessage] + responseMessages
    }

    private func systemChatMessage() -> ChatMessage {
        return ChatMessage(role: .system, content:
            """
            if user requests to write code, output JavaScript that will be launched on the page that contains canvas element with id 'my-canvas', its width and height is already set to the size of the page.

            assume that every user message starts with "Write a JavaScript code that..." , unless such concatenation makes no sense, for example if message is "How are you?"

            prefer writing code that fetches requested data from known public APIs that dont require any keys

            never write a code that shows something in JavaScript console, instead, draw requested data beautifully on canvas. Be creative: if data can be represented with graph, do it

            any JS code that you output MUST be enclosed between `\(VAMessage.JSStartMarker)` and `\(VAMessage.JSEndMarker)` like that :
            \(VAMessage.JSStartMarker)
            //code goes here
            \(VAMessage.JSEndMarker)

            avoid explanations as much as possible, be concise
            """)
    }

    func openAIMessages(with messages: [VAMessage]) -> [ChatMessage] {
        return [systemChatMessage()] + messages.compactMap { message in
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
