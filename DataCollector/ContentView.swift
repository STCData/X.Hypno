//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showTabBar = false
    @State private var isTermOpened = false

    var tabView: some View {
        TabView {
            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)

            BrowserView()
                .tabItem {
                    Label("Browser", systemImage: "globe")
                }
                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)

//            TermView()
//                .tabItem {
//                    Label("Terminal", systemImage: "terminal")
//                }
//                .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        }
    }

    var body: some View {
        ZStack {
            tabView

            SlideoutView(horizontal: false, isSidebarVisible: $isTermOpened) {
                TermView()
                    .padding(EdgeInsets(top: 60, leading: 2, bottom: 2, trailing: 2))
            }

            FloatingButton(action: {
                isTermOpened.toggle()
            }, icon: "terminal", alignment: .topTrailing)
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
