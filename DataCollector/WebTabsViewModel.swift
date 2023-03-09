//
//  WebTabsViewModel.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

class WebTabsViewModel: ObservableObject {
    @Published
    var tabs: [WebTab] = []
    
    init(tabs:[WebTab]) {
        self.tabs = tabs
    }
    
    private func addChild(_ child:WebTab, to parentTab: WebTab) {
        
    }
    
    func openTab(request: URLRequest, fromTab tab:WebTab?) {
        
    }
    
    
    static func requestFrom(_ goTo: String) -> URLRequest? {
        var url: URL? = nil
        if let goToURL = URL(string: goTo) {
            url = goToURL
        } else {
            let escapedQuery = goTo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let urlString = "https://www.google.com/search?q=\(escapedQuery)"
            url = URL(string: urlString)
        }

        guard let url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
