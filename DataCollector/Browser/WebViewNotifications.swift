//
//  WebViewNotifications.swift
//  DataCollector
//
//  Created by standard on 3/19/23.
//

import Foundation

public extension NSNotification.Name {
    static let WebViewDetailsLoaded = NSNotification.Name("WebViewDetailsLoaded")
}

let WebViewLoadedUserInfoWebTab = "WebViewLoadedUserInfoWebTab"
let WebViewLoadedUserInfoWebTitle = "WebViewLoadedUserInfoWebTitle"
let WebViewLoadedUserInfoWebFaviconImage = "WebViewLoadedUserInfoWebFaviconImage"
