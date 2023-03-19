//
//  WebView+FavIcon.swift
//  DataCollector
//
//  Created by standard on 3/19/23.
//

import FaviconFinder
import Foundation
import Logging
private let log = Logger(label: LogLabels.webview.rawValue)

extension WebTab {
    func loadFavIcon() async {
        guard let url = urlRequest.url else { return }
        do {
            let favicon = try await FaviconFinder(url: url).downloadFavicon()

            log.info("URL of Favicon: \(favicon.url)")
            NotificationCenter.default.post(name: .WebViewDetailsLoaded, object: nil, userInfo: [
                WebViewLoadedUserInfoWebTab: self, // fixme
                WebViewLoadedUserInfoWebFaviconImage: favicon.image,
            ])
        } catch {
            log.error("Error: \(error)")
        }
    }
}
