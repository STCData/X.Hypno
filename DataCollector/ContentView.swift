//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct TabbedWebView: View {
    var request: URLRequest
    var body: some View {
        WebView(request: request)
    }
}

struct ContentView: View {
    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [])

    var body: some View {
        HStack(alignment: .top) {
            SidePanelView()
                .padding()
            TabbedWebView(request: webTabsViewModel.currentTab?.urlRequest ?? URLRequest(url: WebTab.blankPageURL))
            
        }.environmentObject(webTabsViewModel)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
