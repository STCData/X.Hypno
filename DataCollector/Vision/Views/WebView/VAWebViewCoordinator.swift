//
//  VAWebViewCoordinator.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Logging
import SwiftUI
import WebKit
private let log = LogLabels.webview.makeLogger()

class VAWebViewCoordinator: NSObject, WKUIDelegate {
    var parent: VAWebView

    init(_ parent: VAWebView) {
        self.parent = parent
    }

    // Delegate methods go here

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame _: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            webView.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

extension VAWebViewCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
//        guard let webTab = tabsViewModel?.currentTab, // fixme
//              let title = webView.title else { return }
//
//        NotificationCenter.default.post(name: .WebViewDetailsLoaded, object: nil, userInfo: [
//            WebViewLoadedUserInfoWebTab: webTab,
//            WebViewLoadedUserInfoWebTitle: title,
//        ])

        webView.initDebug()
        webView.initJS()
    }

    func webView(_: WKWebView, decidePolicyFor _: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == WKNavigationType.linkActivated {
//            let url = navigationAction.request.url
//            log.info("🌐 \(url?.absoluteString ?? "n/a")")
//
//            if let tabsViewModel {
//                DispatchQueue.main.async {
//                    tabsViewModel.openTab(request: navigationAction.request, fromTab: tabsViewModel.currentTab)
//                }
//            }
//            decisionHandler(WKNavigationActionPolicy.allow)
//            return
//        }
//        log.info("🌐 no link")

        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
