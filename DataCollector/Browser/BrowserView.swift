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
    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [WebTab(urlRequest: URLRequest(url: WebTab.blankPageURL))])
    @State private var isSideBarOpened = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.96)
                .ignoresSafeArea()
                .accessibilityIgnoresInvertColors(true)

            TabbedWebView(request: webTabsViewModel.currentTab?.urlRequest ?? URLRequest(url: WebTab.blankPageURL))

            // UIScreen.main.bounds.size.width * 0.9
            SlideoutView(
                isSidebarVisible: $isSideBarOpened, sideBarWidth: UIScreen.main.bounds.size.width * 0.99,
                bgColor: Color(uiColor: .systemGray5)
            ) {
                SidePanelView()
                    .padding(EdgeInsets(top: 60, leading: 12, bottom: 42, trailing: 12))
            }
            FloatingAtCorner(alignment: .bottomTrailing) {
                FloatingButton(action: {
                    isSideBarOpened.toggle()
                }, icon: "square.on.square", width: 64, height: 64, cornerRadius: 12)
            }
        }
        .environmentObject(webTabsViewModel)
        .padding(.top, 30)
        .ignoresSafeArea()
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
