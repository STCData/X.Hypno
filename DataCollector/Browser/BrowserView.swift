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
    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [])
    @State private var isSideBarOpened = false

    var body: some View {
        ZStack(alignment: .top) {
            TabbedWebView(request: webTabsViewModel.currentTab?.urlRequest ?? URLRequest(url: WebTab.blankPageURL))

            SlideoutView(isSidebarVisible: $isSideBarOpened) {
                SidePanelView()
                    .padding(EdgeInsets(top: 60, leading: 2, bottom: 2, trailing: 2))
            }
            FloatingButton(action: {
                isSideBarOpened.toggle()
            }, icon: "square.on.square", alignment: .bottomTrailing)
        }
        .environmentObject(webTabsViewModel)
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
