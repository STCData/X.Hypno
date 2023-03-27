//
//  SimpleCameraView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct CameraView: View {
    @State private var isFlashLight = false
    @State private var isBackFacingCamera = true
    @State private var isVisionViewShown = true

    var body: some View {
        ZStack {
            #if os(iOS)
                HostedCameraViewController()
            #endif

            VoiceAssistantView()
                .padding(.top, 52)
                .frame(maxWidth: .infinity)

            if isVisionViewShown {
                VisionView(visionViewModel: VisionViewModel(observationPublisher: VisionPool.cameraPool.observationsSubject))
                    .opacity(0.6)
            }

            Button {
                isVisionViewShown.toggle()
            } label: {}
                .keyboardShortcut("o", modifiers: .command)

            FloatingAtCorner(alignment: .topLeading) {
                HStack {
                    FloatingButton(action: {
                        isFlashLight.toggle()
                    }, icon: isFlashLight ? "flashlight.on.fill" : "flashlight.off.fill", color: isFlashLight ? FloatingButton.brightColor : FloatingButton.enabledColor)
                    FloatingButton(action: {
                        isBackFacingCamera.toggle()
                    }, icon: isBackFacingCamera ? "arrow.triangle.2.circlepath.camera.fill" : "arrow.triangle.2.circlepath.camera", color: FloatingButton.enabledColor)
                }
            }
        }
        .ignoresSafeArea()
    }
}
