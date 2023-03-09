//
//  WebTab.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation



struct WebTab: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    let title: String
    let url: URL
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

        
        
