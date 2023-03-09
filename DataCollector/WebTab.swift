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
    
    mutating func addChild(_ child: WebTab) {
        var newChildren = children ?? []
        newChildren.append(child)
        children = newChildren
    }
    
    mutating func updateChild(_ child: WebTab, with newChild: WebTab) {
        if let i = children?.firstIndex(of: child) {
            children?[i] = newChild
        }
    }
}

extension WebTab {
    func findParent(for child: WebTab) -> WebTab? {
        var stack = [self]
        while !stack.isEmpty {
            let current = stack.removeLast()
            if let children = current.children {
                if children.contains(child) {
                    return current
                }
            }
            
            if let children = current.children {
                stack.append(contentsOf: children)
            }
        }
        return nil
    }
    

}

      



extension WebTab {
    static let blankPageURL = URL(string: "https://apple.com")!
}
