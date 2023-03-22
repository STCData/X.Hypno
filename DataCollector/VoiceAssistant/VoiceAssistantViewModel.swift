//
//  VoiceAssistantViewModel.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Combine
import Foundation

class VoiceAssistantViewModel: ObservableObject {
    private let assistant: VAAssistant = VADummyAssistant()
    private var speechRecognitionSub = Set<AnyCancellable>()

    private var speechRecognizer = SpeechRecognizer()

    @Published
    var textfieldMessageInput = ""

    @Published
    var messages = [VAMessage]()

    @Published
    var isRecording = false {
        didSet {
            if isRecording {
                start()
            } else {
                stop()
            }
        }
    }

    init() {}

    private func updateCurrentlyRecordingMessage(with text: String) {
        var newMessages = messages

        if newMessages.last?.role == .userRecordingInProcess {
            newMessages.removeLast()
            messages = newMessages
        }

        guard isRecording else { return }

        let currentlyRecordingMessage = VAMessage(text: text, role: .userRecordingInProcess)
        newMessages.append(currentlyRecordingMessage)
        messages = newMessages
    }

    private func start() {
        speechRecognizer.reset()
        speechRecognizer.transcribe()
        speechRecognizer.$transcript.sink { transcript in
            print("VOICE! \(transcript)")
            self.updateCurrentlyRecordingMessage(with: transcript)

        }.store(in: &speechRecognitionSub)
    }

    public func commitTextfield() {
        commitUserMessage(text: textfieldMessageInput)
        textfieldMessageInput = ""
    }

    private func commitUserMessage(text: String) {
        var newMessages = messages

        if newMessages.last?.role == .userRecordingInProcess {
            newMessages.removeLast()
            messages = newMessages
        }

        let txt = text
        let chat = newMessages

        Task {
            let resultMessages = await assistant.respond(to: txt, in: chat)
            DispatchQueue.main.async {
                self.messages = resultMessages
            }
        }
    }

    private func stop() {
        speechRecognizer.stopTranscribing()
        let text = speechRecognizer.transcript
        speechRecognizer.transcript = ""
        commitUserMessage(text: text)
    }
}
