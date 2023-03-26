//
//  VADoubleTapOpenAIAssistant.swift
//  DataCollector
//
//  Created by standard on 3/26/23.
//

import Combine
import Foundation

class VADoubleTapOpenAIAssistant: VAAssistant {
    var assistantCodeSubject: AnyPublisher<String, Never>? {
        return passthroughCodeSubject.eraseToAnyPublisher()
    }

    private let passthroughCodeSubject = PassthroughSubject<String, Never>()

    var assistantGUIAutomateSubject: AnyPublisher<String, Never>? {
        return passthroughGUIAutomateSubject.eraseToAnyPublisher()
    }

    private let passthroughGUIAutomateSubject = PassthroughSubject<String, Never>()

    var assistantBrowserAutomateSubject: AnyPublisher<String, Never>? {
        return passthroughBrowserAutomateSubject.eraseToAnyPublisher()
    }

    private let passthroughBrowserAutomateSubject = PassthroughSubject<String, Never>()

    var assistantBashCodeSubject: AnyPublisher<String, Never>? {
        return passthroughBashCodeSubject.eraseToAnyPublisher()
    }

    private let passthroughBashCodeSubject = PassthroughSubject<String, Never>()

    private var subs = Set<AnyCancellable>()

    static let shared = VADoubleTapOpenAIAssistant()

    let classificatorAssistant = try! VAOpenAIAssistant(systemMessage: PromptJSGenerator.shared.promptIntro)

    private var assistants = [IntroPrompts: VAAssistant]()

    private var introsForMessages = [String: IntroPrompts]()

    private func initializeAssistant(prompt: IntroPrompts) throws -> VAAssistant {
        let assistant = try VAOpenAIAssistant(systemMessage: prompt.prompt)
        if prompt == .JavaScriptObservations || prompt == .JavaScript {
            assistant.passthroughCodeSubject.subscribe(passthroughCodeSubject)
                .store(in: &subs)
        }
        return assistant
    }

    func respond(to message: String, in chat: [VAMessage]) async -> [VAMessage] {
        let userMessage = VAMessage(text: message, role: .user)
        var responseMessages = [VAMessage]()

        if chat.count == 0 && !introsForMessages.keys.contains(message) {
            let promptClassificationChat = await classificatorAssistant.respond(to: message, in: [VAMessage]())
            if let classificationMessage = promptClassificationChat.last {
                let classificationText = classificationMessage.text
                let classificationTextCleared = classificationText.replacingOccurrences(of: "[\\s.]+", with: "", options: .regularExpression)

                if let introPrompt = IntroPrompts(rawValue: classificationTextCleared) {
                    introsForMessages[message] = introPrompt
                    if !assistants.keys.contains(introPrompt) {
                        do {
                            assistants[introPrompt] = try initializeAssistant(prompt: introPrompt)
                            responseMessages = [VAMessage(text: "classified as \(introPrompt.rawValue)", role: .assistantClientSideService)]
                        } catch {
                            responseMessages = [VAMessage(text: "error initializing classified assistant", role: .error)]
                        }
                    }
                } else {
                    responseMessages = [VAMessage(text: "open ai returned wrong classification: '\(classificationText)'", role: .error)]
                }
            } else {
                responseMessages = [VAMessage(text: "no classification received from open ai", role: .error)]
            }
        }

        let firstMessageText = chat.firstUserMessageText ?? message
        if let introPrompt = introsForMessages[firstMessageText] {
            return await assistants[introPrompt]!.respond(to: message, in: responseMessages + chat)
        } else {
            return [userMessage] + responseMessages // response messages should contain error
        }
    }
}
