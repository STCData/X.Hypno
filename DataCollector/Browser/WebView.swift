//
//  WebView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Logging
import SwiftUI
import WebKit
private let log = Logger(label: LogLabels.webview.rawValue)

#if os(iOS) || os(watchOS) || os(tvOS)

    struct WebView: UIViewRepresentable {
        @EnvironmentObject
        var tabsViewModel: WebTabsViewModel

        var request: URLRequest

        func makeUIView(context _: Context) -> WKWebView {
            return WKWebView()
        }

        func updateUIView(_ webView: WKWebView, context: Context) {
            webView.uiDelegate = context.coordinator
            webView.navigationDelegate = context.coordinator
//

            DispatchQueue.main.async {
                webView.load(request)
            }
        }
    }

#elseif os(macOS)

    struct WebView: NSViewRepresentable {
        @EnvironmentObject
        var tabsViewModel: WebTabsViewModel

        var request: URLRequest

        func makeNSView(context _: Context) -> WKWebView {
            return WKWebView()
            log.trace("makeNSView(context _: Context)")
        }

        func updateNSView(_ webView: WKWebView, context: Context) {
            webView.uiDelegate = context.coordinator
            webView.navigationDelegate = context.coordinator

            log.trace("updateNSView(_ webView: WKWebView, context: Context)")

            DispatchQueue.main.async {
                webView.load(request)
            }
        }
    }

#else

#endif

extension WebView {
    func makeCoordinator() -> WebViewCoordinator {
        let coordinator = WebViewCoordinator(self)
        coordinator.tabsViewModel = tabsViewModel
        return coordinator
    }
}

class WebViewCoordinator: NSObject, WKUIDelegate {
    weak var tabsViewModel: WebTabsViewModel?

    var parent: WebView

    init(_ parent: WebView) {
        self.parent = parent
    }

    // Delegate methods go here

    func webView(_: WKWebView, runJavaScriptAlertPanelWithMessage _: String, initiatedByFrame _: WKFrameInfo, completionHandler _: @escaping () -> Void) {
        // alert functionality goes here
    }
}

extension WebViewCoordinator: WKNavigationDelegate {
    // fixme
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if let title = webView.title {
//            if let tabsViewModel {
//                tabsViewModel.currentTab?.setTitle(title)
//            }
//        }
//    }
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            log.info("🌐 \(navigationAction.request.url?.absoluteString ?? "n/a")")

            if let tabsViewModel {
                tabsViewModel.openTab(request: navigationAction.request, fromTab: tabsViewModel.currentTab)
            }

            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        log.info("🌐 no link")

        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
