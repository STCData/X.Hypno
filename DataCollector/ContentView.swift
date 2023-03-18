//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showTabBar = false

    var body: some View {
        TabView {
            BrowserView()
                .tabItem {
                    Label("Browser", systemImage: "globe")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)

            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        }
        .onShake {
            withAnimation(Animation.easeOut(duration: 0.08)) {
                showTabBar.toggle()
            }
            if showTabBar {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(Animation.easeOut(duration: 0.2)) {
                        showTabBar = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
