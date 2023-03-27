//
//  BrowserView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct TabbedWebView: View {
    var request: URLRequest
    var body: some View {
        WebView(request: request)
    }
}

struct BrowserView: View {
    @State private var isVisionViewShown = true

    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [WebTab(urlRequest: URLRequest(url: WebTab.blankPageURL))])
    @State private var isSideBarOpened = false

    @State
    private var unsafeAreaColor = unsafeAreaColorDefault

    @State var webViewBlurRadius: CGFloat = 0

    private static let unsafeAreaColorDefault = Color.black.opacity(0.96)
    private static let unsafeAreaColorTapped = Color.white

    var body: some View {
        ZStack(alignment: .top) {
            Color(.white)
                .colorMultiply(self.unsafeAreaColor)
                .ignoresSafeArea()
                .accessibilityIgnoresInvertColors(true)
                .allowsHitTesting(false)

            TabbedWebView(request: webTabsViewModel.currentTab?.urlRequest ?? URLRequest(url: WebTab.blankPageURL))
                .blur(radius: webViewBlurRadius)
                .onChange(of: isSideBarOpened, perform: { value in
                    if value {
                        withAnimation { webViewBlurRadius = 13 }
                    } else {
                        withAnimation { webViewBlurRadius = 0 }
                    }
                })

            VoiceAssistantView()
                .frame(maxWidth: .infinity)

            if isVisionViewShown {
                VisionView(visionViewModel: VisionViewModel(observationPublisher: VisionPool.broadcastPool.observationsSubject
                        .debounce(for: .seconds(0.1), scheduler: RunLoop.main)))
                    .opacity(0.6)
            }

            FloatingAtCorner(alignment: .topLeading) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.unsafeAreaColor = BrowserView.unsafeAreaColorTapped
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(Animation.easeOut(duration: 0.2)) {
                            self.unsafeAreaColor = BrowserView.unsafeAreaColorDefault
                        }
                    }

                } label: {
                    Color(.clear)
                        .frame(width: 70)
                        .frame(height: 70)
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea()

            // UIScreen.main.bounds.size.width * 0.9
            SlideoutView(
                opacity: 0.8,
                isSidebarVisible: $isSideBarOpened, sideBarWidth: UIScreen.main.bounds.size.width * 0.99,
                bgColor: Color(uiColor: .systemGray6).opacity(0.89),
                shadowColor: .clear // .black.opacity(0.9)
            ) {
                SidePanelView(isSidebarVisible: $isSideBarOpened)
                    .padding(EdgeInsets(top: 60, leading: 12, bottom: 42, trailing: 12))
            }
            FloatingAtCorner(alignment: .bottomTrailing) {
                FloatingButton(action: {
                    isSideBarOpened.toggle()
                }, icon: "square.on.square", width: 64, height: 64, cornerRadius: 12)
            }

            Button(action: {
                isSideBarOpened.toggle()
            }, label: {})
                .keyboardShortcut("g", modifiers: .command)
            Button {
                isVisionViewShown.toggle()
            } label: {}
                .keyboardShortcut("o", modifiers: .command)
        }
        .environmentObject(webTabsViewModel)
//        .padding(.top, 30)
        .ignoresSafeArea()
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
