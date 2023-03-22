//
//  VoiceAssistantView.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import SwiftUI

struct VoiceAssistantView: View {
    @Namespace var topID
    @Namespace var bottomID

    @StateObject
    private var viewModel = VoiceAssistantViewModel()

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
                        VoiceAssistantMessageBalloon(message: msg)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation {
                            value.scrollTo(bottomID)
                        }
                    }
                    Spacer()
                        .frame(height: 0)
                        .id(bottomID)
                }
            }
            Spacer()

            FloatingButton(action: {
                viewModel.isRecording.toggle()
            }, icon: "waveform.path", width: 64, height: 64, cornerRadius: 22, color: viewModel.isRecording ? FloatingButton.recColor : FloatingButton.enabledColor)
        }
    }
}

struct VoiceAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceAssistantView()
    }
}
