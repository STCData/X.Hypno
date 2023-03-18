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

    var body: some View {
        HStack(alignment: .top) {
            SidePanelView()
                .padding()
            TabbedWebView(request: webTabsViewModel.currentTab?.urlRequest ?? URLRequest(url: WebTab.blankPageURL))

        }.environmentObject(webTabsViewModel)
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
