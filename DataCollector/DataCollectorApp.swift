//
//  DataCollectorApp.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

@main
struct DataCollectorApp: App {
    init() {
        LogInit()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(Broadcast.shared)
                    .environmentObject(VisionPool.cameraPool)

                VoiceAssistantView()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
