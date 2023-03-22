//
//  VoiceAssistantView.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import SwiftUI

extension View {
    func onEnter(@Binding of text: String, action: @escaping () -> Void) -> some View {
        onChange(of: text) { newValue in
            if let last = newValue.last, last == "\n" {
                text.removeLast()
                // do your submit logic here?
                action()
            }
        }
    }
}

struct VoiceAssistantView: View {
    @Namespace var topID
    @Namespace var bottomID

    func submitTextField() {
        //                                isTextFieldFocused = false
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            viewModel.commitTextfield()
            isTextFieldFocused = true
        }
    }

    @StateObject
    private var viewModel = VoiceAssistantViewModel()
    @FocusState var isTextFieldFocused: Bool

    @State
    private var isKeyboardInputActive = false

    var body: some View {
        VStack {
            Spacer()
                .frame(minHeight: 0, maxHeight: .infinity)
            ScrollViewReader { value in

                ScrollView {
                    Spacer()
                        .frame(maxHeight: .infinity)
                        .id(topID)

                    ForEach(viewModel.messages) { msg in
                        VoiceAssistantMessageBalloon(message: msg) {
                            Spacer()
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation {
                            value.scrollTo(bottomID)
                        }
                    }

                    if isKeyboardInputActive {
                        VoiceAssistantMessageBalloon(message: VAMessage(text: "", role: .userTyping)) {
                            TextField("", text: $viewModel.textfieldMessageInput, axis: .vertical)
                                .onSubmit(submitTextField)
                                .onEnter($of: $viewModel.textfieldMessageInput, action: submitTextField)

                                .textFieldStyle(.roundedBorder)

                                .focused($isTextFieldFocused)
                        }
                    }

                    Spacer()
                        .frame(height: 0)
                        .id(bottomID)
                }
            }
            .frame(maxWidth: .infinity)
//            .adaptsToKeyboard()
            Spacer()

            if !isTextFieldFocused {
                FloatingButton(action: {
                    if !isKeyboardInputActive {
                        viewModel.isRecording.toggle()
                    }

                }, longTapAction: {
                    isKeyboardInputActive.toggle()
                    if isKeyboardInputActive, viewModel.isRecording {
                        viewModel.isRecording = false
                    }
                    if isKeyboardInputActive {
                        isTextFieldFocused = true
                    }
                },
                icon: isKeyboardInputActive ? "keyboard" : "waveform.path", width: 64, height: 64, cornerRadius: 22, color: viewModel.isRecording ? FloatingButton.recColor : FloatingButton.enabledColor)
            }
        }
    }
}

struct VoiceAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAssistantView()
    }
}
