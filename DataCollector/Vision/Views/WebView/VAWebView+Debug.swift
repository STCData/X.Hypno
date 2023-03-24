//
//  VAWebView+Debug.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import WebKit

extension WKWebView {
    func initDebug() {
        evaluateJavaScript(PromptJSGenerator.shared.debugJS) { _, error in
            if error == nil {
//                print(result)
//                print(result)
            } else {
//                print(error)
                print(error)
            }
        }
    }
}
