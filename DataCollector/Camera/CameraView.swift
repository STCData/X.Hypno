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

    var body: some View {
        ZStack {
            #if os(iOS)
                HostedCameraViewController()
            #endif
            VisionView(visionViewModel: VisionViewModel(observationPublisher: VisionPool.cameraPool.observationsSubject))
            FloatingAtCorner(alignment: .topLeading) {
                VStack {
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
