//
//  WebTabsViewModel.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI


#if os(iOS) || os(watchOS) || os(tvOS)

import UIKit

fileprivate func isValidURL(_ url: URL) -> Bool {
    return UIApplication.shared.canOpenURL(url)
}
#elseif os(macOS)

import AppKit

fileprivate func isValidURL(_ url: URL) -> Bool {
    return url.absoluteString.starts(with: "http") // fixme
}

#else


#endif


class WebTabsViewModel: ObservableObject {
    @Published
    var tabs: [WebTab] = []
    
    @Published
    var currentTab: WebTab? = nil
    
    init(tabs:[WebTab]) {
        self.tabs = tabs
    }
    
    private func addChild(_ child:WebTab, to parentTab: WebTab) {
        
    }
    
    func selectTab(_ tab: WebTab) {
        currentTab = tab //fixme check if present
    }
    
    func openTab(request: URLRequest, fromTab parentTab:WebTab?) {
        let newTab = WebTab(urlRequest: request)
        if let parentTab {
            addChild(newTab, to: parentTab)
        } else {
            tabs.append(newTab)
        }
        selectTab(newTab)
    }
    
    
    
    
    static func googleRequestFrom(_ searchTerm: String) -> URLRequest? {
        let escapedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://www.google.com/search?q=\(escapedQuery)"
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil

    }
    
    static func requestFrom(_ goTo: String) -> URLRequest? {
        guard let url = URL(string: goTo) else {
            return googleRequestFrom(goTo)
        }
        
        guard isValidURL(url) else {
            return googleRequestFrom(goTo)
        }

        return URLRequest(url: url)
    }
}
