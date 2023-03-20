//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isDebugUIShown = true
    @State private var isTabbarShown = false
    @State private var isTermOpened = false

    var tabView: some View {
        TabView {
            BrowserView()
                .tabItem {
                    Label("Browser", systemImage: "globe")
                }
                .toolbar(isTabbarShown ? .visible : .hidden, for: .tabBar)

            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
                .toolbar(isTabbarShown ? .visible : .hidden, for: .tabBar)
        }
    }

    var body: some View {
        ZStack {
            tabView

            SlideoutView(horizontal: false,
                         opacity: 0.01,
                         isSidebarVisible: $isTermOpened,
                         bgColor: .black.opacity(0.9))
            {
                TermView()
                    .padding(EdgeInsets(top: 60, leading: 2, bottom: 2, trailing: 2))
            }

            FloatingAtCorner(alignment: .topTrailing) {
                HStack {
                    FloatingButton(action: {
                        isTermOpened.toggle()
                    }, icon: "terminal")

                    FloatingButton(action: {
                        Broadcast.shared.startInApp()
                    }, icon: "rectangle.dashed.badge.record")
                    FloatingButton(action: {
                        Broadcast.shared.startSystemWide()
                    }, icon: "menubar.dock.rectangle.badge.record")
                }
            }.if(!isDebugUIShown) {
                $0.hidden()
            }

            VisionView(visionViewModel: VisionViewModel(visionPool: VisionPool.broadcastPool))
        }
        .ignoresSafeArea()
        .onShake {
            withAnimation(Animation.easeOut(duration: 0.08)) {
                isTabbarShown.toggle()
            }
            if isTabbarShown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(Animation.easeOut(duration: 0.2)) {
                        isTabbarShown = false
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
