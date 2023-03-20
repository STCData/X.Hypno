//
//  WebView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Logging
import SwiftUI
import WebKit
private let log = LogLabels.webview.makeLogger()

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
