//
//  WebTab.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation



struct WebTab: Hashable, Identifiable, CustomStringConvertible {
    init (urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    init (title:String, url: URL, children: [WebTab]? = nil) {
        self.titleLoaded = title
        self.urlRequest = URLRequest(url: url)
        self.children = children
    }
    
    var id: Self { self }
    var title: String {
        if let t = titleLoaded {
            return t
        } else {
            return urlRequest.url?.absoluteString ?? "n/a"
        }
    }
    
    var titleLoaded: String? = nil
    
    mutating func setTitle(_ title: String) {
        titleLoaded = title
    }
    
    let urlRequest: URLRequest
    var children: [WebTab]? = nil
    var description: String {
        switch children {
        case nil:
            return "📄 \(title)"
        case .some(let children):
            return children.isEmpty ? "📂 \(title)" : "📁 \(title)"
        }
    }
}

        
        

extension WebTab {
    static let blankPageRequest = URLRequest(url: URL(string: "https://apple.com")!)
}
