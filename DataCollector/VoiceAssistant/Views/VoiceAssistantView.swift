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

extension View {
    @ViewBuilder
    private func onTapBackgroundContent(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        if enabled {
            Color.clear
                .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
                .contentShape(Rectangle())
                .onTapGesture(perform: action)
        }
    }

    func onTapBackground(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        background(
            onTapBackgroundContent(enabled: enabled, action)
        )
    }
}

struct VoiceAssistantView: View {
    @Namespace var textfieldID
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

    @State
    private var isHidden = false

    var content: some View {
        VStack {
            //            Spacer()
            //                .frame(minHeight: 0, maxHeight: .infinity)
            ScrollViewReader { value in

                ScrollView {
                    //                    Spacer()
                    //                        .frame(maxHeight: .infinity)
                    //                        .id(topID)

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
                                .keyboardType(.asciiCapable)
                                .autocorrectionDisabled(true)
                                .onSubmit(submitTextField)
                                .onEnter($of: $viewModel.textfieldMessageInput, action: submitTextField)
                                .onChange(of: isTextFieldFocused) { isFocused in
                                    if isFocused {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            value.scrollTo(bottomID)
                                        }
                                    }
                                }

                                .textFieldStyle(.roundedBorder)
                                .focused($isTextFieldFocused)
                                .id(textfieldID)
                        }
                    }

                    Spacer()
                        .frame(height: 0)
                        .id(bottomID)
                }

                .gesture(
                    DragGesture().onChanged { value in

                        if value.translation.height > 0 {
                            isTextFieldFocused = false

//                            print("Scroll down")
                        } else {
//                            print("Scroll up")
                        }
                    }
                )
            }
            .onTapBackground(enabled: isTextFieldFocused) {
                isTextFieldFocused = false
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

    var body: some View {
        ZStack {
            if !isHidden {
                content
            }
            Button(action: {
                isHidden = false
                isKeyboardInputActive = true
//                viewModel.isRecording = false
                isTextFieldFocused = true
            }, label: {})
                .keyboardShortcut("p", modifiers: .command)

            Button(action: {
                isHidden.toggle()
            }, label: {})
                .keyboardShortcut("p", modifiers: [.option, .command])
        }

//        .adaptsToKeyboard()
    }
}

struct VoiceAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAssistantView()
    }
}
