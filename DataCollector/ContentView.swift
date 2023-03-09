//
//  ContentView.swift
//  DataCollector
//
//  Created by standard on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HStack {
            WebTabTreeView(webTabs: [])
                .padding()
            WebView(url: URL(string: "https://apple.com")!)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
