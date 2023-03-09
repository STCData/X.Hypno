//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var webTabsViewModel = WebTabsViewModel(tabs: [])

    var body: some View {
        HStack(alignment: .top) {
            SidePanelView()
                .padding()
            WebView(request: webTabsViewModel.currentTab?.urlRequest ?? WebTab.blankPageRequest)
        }.environmentObject(webTabsViewModel)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
