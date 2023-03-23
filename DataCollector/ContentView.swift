//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

private enum Tabs: CaseIterable {
    case first
    case second
}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

// @available(macOS 13.0, *)
struct ContentView: View {
    @State private var isDebugUIShown = true
    @State private var isTabbarShown = false
    @State private var isTermOpened = false
    @State private var tabSelection = Tabs.first

    @EnvironmentObject
    var broadcast: Broadcast

    @EnvironmentObject
    var cameraVisionPool: VisionPool

    var tabView: some View {
        TabView(selection: $tabSelection) {
            CameraView()
//                .tabItem {
//                    Label("Camera", systemImage: "camera")
//                }
//                .toolbar(isTabbarShown ? .visible : .hidden, for: .tabBar)
            #if os(iOS)

.toolbar(.hidden, for: .tabBar)
            #endif

.tag(Tabs.first)

            BrowserView()
//                .tabItem {
//                    Label("Browser", systemImage: "globe")
//                }
//                .toolbar(isTabbarShown ? .visible : .hidden, for: .tabBar)
            #if os(iOS)

.toolbar(.hidden, for: .tabBar)
            #endif
.tag(Tabs.second)
        }
        #if os(iOS)

        .toolbar(.hidden, for: .tabBar)
        #endif
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
                HStack(alignment: .top) {
                    FloatingButton(action: {
                        isTermOpened.toggle()
                    }, icon: "terminal", color: isTermOpened ? FloatingButton.disabledColor : FloatingButton.enabledColor)

                    FloatingButton(action: {
                        cameraVisionPool.isOn.toggle()
                    }, icon: "camera.viewfinder", color: cameraVisionPool.isOn ? FloatingButton.recColor : FloatingButton.enabledColor)

                    VStack {
                        FloatingButton(action: {
                            broadcast.isSystemWideInProgress.toggle()
                        }, icon: "menubar.dock.rectangle.badge.record", color: broadcast.isSystemWideInProgress ? FloatingButton.recColor : FloatingButton.enabledColor)
                        FloatingButton(action: {
                            broadcast.isInAppInProgress.toggle()
                        }, icon: "rectangle.dashed.badge.record", color: broadcast.isInAppInProgress ? FloatingButton.recColor : FloatingButton.enabledColor)
                    }
                }
            }.if(!isDebugUIShown) {
                $0.hidden()
            }

            VisionView(visionViewModel: VisionViewModel(visionPool: VisionPool.broadcastPool))
        }
        .ignoresSafeArea()
        .onShake {
            self.tabSelection = self.tabSelection.next()
            /*
             withAnimation(Animation.easeOut(duration: 0.08)) {
                 isTabbarShown.toggle()
             }
             if isTabbarShown {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                     withAnimation(Animation.easeOut(duration: 0.2)) {
                         isTabbarShown = false
                     }
                 }
             }*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
