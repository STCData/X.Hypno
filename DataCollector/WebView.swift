//
//  WebView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//


import SwiftUI
import WebKit
 
#if os(iOS) || os(watchOS) || os(tvOS)

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#elseif os(macOS)

struct WebView: NSViewRepresentable {
    @EnvironmentObject
    var tabsViewModel: WebTabsViewModel
 
    var request: URLRequest
 
    func makeNSView(context: Context) ->  WKWebView {
        return WKWebView()
    }
 
    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
//
            
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

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // alert functionality goes here
    }
}

extension WebViewCoordinator: WKNavigationDelegate {
    
    
    //fixme
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if let title = webView.title {
//            if let tabsViewModel {
//                tabsViewModel.currentTab?.setTitle(title)
//            }
//        }
//    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
           if navigationAction.navigationType == WKNavigationType.linkActivated {
               print("link")
               
               if let tabsViewModel {
                   tabsViewModel.openTab(request: navigationAction.request, fromTab: tabsViewModel.currentTab)
               }
               

               decisionHandler(WKNavigationActionPolicy.allow)
               return
           }
           print("no link")
           decisionHandler(WKNavigationActionPolicy.allow)
    }

}
