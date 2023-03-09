//
//  WebTab.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation



class WebTab: Hashable, Identifiable, CustomStringConvertible {
    var id = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
    static func == (lhs: WebTab, rhs: WebTab) -> Bool {
        lhs.id == rhs.id
    }
    
    init (urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    init (title:String, url: URL, children: [WebTab]? = nil) {
        self.titleLoaded = title
        self.urlRequest = URLRequest(url: url)
        self.children = children
    }
    
    var title: String {
        if let t = titleLoaded {
            return t
        } else {
            return urlRequest.url?.absoluteString ?? "n/a"
        }
    }
    
    var titleLoaded: String? = nil
    
    func setTitle(_ title: String) {
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
    
    func addChild(_ child: WebTab) {
        var newChildren = children ?? []
        newChildren.append(child)
        children = newChildren
    }
    
    func updateChild(_ child: WebTab, with newChild: WebTab) {
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
