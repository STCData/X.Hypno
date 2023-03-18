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
                    Label("Browser", systemImage: "list.dash")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)

            SimpleCameraView()
                .tabItem {
                    Label("Camera", systemImage: "square.and.pencil")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        }
        .onShake {
            showTabBar.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
