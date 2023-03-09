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
    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [
        WebTab(title: "Apple", url: URL(string:"https://www.apple.com/")!, children:[
            WebTab(title: "OutlineGroup | Apple Developer Documentation", url: URL(string: "https://developer.apple.com/documentation/swiftui/outlinegroup")!)
        ]),
        WebTab(title: "Google", url: URL(string:"https://www.google.com/?client=safari")!, children:[
            WebTab(title: "swiftu tree view - Пошук Google", url: URL(string:"https://www.google.com/search?client=safari&rls=en&q=swiftu+tree+view&ie=UTF-8&oe=UTF-8")!, children:[]),
        ])
        ])

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
