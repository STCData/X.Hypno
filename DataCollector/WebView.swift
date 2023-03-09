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
    
 
    var request: URLRequest
 
    func makeNSView(context: Context) ->  WKWebView {
        return WKWebView()
    }
 
    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.load(request)
    }
}


#else


#endif
