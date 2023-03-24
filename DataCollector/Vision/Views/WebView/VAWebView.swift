//
//  VAWebView.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import SwiftUI

import Combine
import Vision
import WebKit

private let log = LogLabels.webview.makeLogger()

#if os(iOS) || os(watchOS) || os(tvOS)

    struct VAWebView: UIViewRepresentable {
        let observationPublisher: any Publisher<[VNObservation], Never>

        init(observationPublisher: any Publisher<[VNObservation], Never>) {
            self.observationPublisher = observationPublisher
        }

//        var request: URLRequest

        func makeUIView(context _: Context) -> ObservingVisionWebView {
            let webView = ObservingVisionWebView(observationPublisher: observationPublisher)
            webView.isOpaque = false
            webView.backgroundColor = UIColor.clear
            webView.scrollView.backgroundColor = UIColor.clear
            log.trace("makeNSView(context _: Context)")
//            initDebug(in: webView)
            webView.loadHTMLString(PromptJSGenerator.shared.observingVisionWebViewHTML, baseURL: nil)

            return webView
        }

        func updateUIView(_ webView: ObservingVisionWebView, context: Context) {
            webView.uiDelegate = context.coordinator
            webView.navigationDelegate = context.coordinator

//
//
//            DispatchQueue.main.async {
//                webView.load(URLRequest(url: URL(string: "https://google.com")!))
//                initDebug(in: webView)
//
//            }
        }
    }

#elseif os(macOS)
/*
 
     struct VAWebView: NSViewRepresentable {
 //        var request: URLRequest
 
         func makeNSView(context _: Context) -> ObservingVisionWebView {
             let webView = WKWebView()
             webView!.isOpaque = false
             webView!.backgroundColor = UIColor.clear
             webView!.scrollView.backgroundColor = UIColor.clear
             log.trace("makeNSView(context _: Context)")
 
             return webView
         }
 
         func updateNSView(_ webView: ObservingVisionWebView, context: Context) {
             webView.uiDelegate = context.coordinator
             webView.navigationDelegate = context.coordinator
 
             log.trace("updateNSView(_ webView: WKWebView, context: Context)")
 //
 //            DispatchQueue.main.async {
 //                webView.load(request)
 //            }
         }
     }
 
 */
#else

#endif

extension VAWebView {
    func makeCoordinator() -> VAWebViewCoordinator {
        let coordinator = VAWebViewCoordinator(self)

        return coordinator
    }
}
