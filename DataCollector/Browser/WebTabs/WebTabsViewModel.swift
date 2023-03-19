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

    init(tabs: [WebTab]) {
        self.tabs = tabs

        NotificationCenter.default.addObserver(self, selector: #selector(handleWebViewDetailsLoadedNotification(_:)), name: .WebViewDetailsLoaded, object: nil)
    }

    @objc private func handleWebViewDetailsLoadedNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let webTab = userInfo[WebViewLoadedUserInfoWebTab] as? WebTab
        {
            if let webTitle = userInfo[WebViewLoadedUserInfoWebTitle] as? String {
                DispatchQueue.main.async {
                    webTab.title = webTitle
                }
            }
            /*
             if let webFaviconImage = userInfo[WebViewLoadedUserInfoWebFaviconImage] as? UIImage {

             }*/
        }
    }

    private func addChild(_ child: WebTab, to parentTab: WebTab) {
        parentTab.addChild(child)
    }

    func selectTab(_ tab: WebTab) {
        currentTab = tab // fixme check if present
    }

    func openTab(request: URLRequest, fromTab parentTab: WebTab?) {
        let newTab = WebTab(urlRequest: request)
        Task {
            await newTab.loadFavIcon()
        }

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
