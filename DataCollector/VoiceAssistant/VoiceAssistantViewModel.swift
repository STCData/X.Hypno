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

    private func stop() {
        speechRecognizer.stopTranscribing()
        var newMessages = messages
        var text = speechRecognizer.transcript
        speechRecognizer.transcript = ""
        if newMessages.last?.role == .userRecordingInProcess {
            text = newMessages.last!.text
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
}
