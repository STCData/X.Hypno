//
//  WebTab+Previews.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation

extension WebTab {
    static var previewTabs = [
        WebTab(title: "Apple", url: URL(string:"https://www.apple.com/")!, children:[
            WebTab(title: "OutlineGroup | Apple Developer Documentation", url: URL(string: "https://developer.apple.com/documentation/swiftui/outlinegroup")!)
        ]),
        WebTab(title: "Google", url: URL(string:"https://www.google.com/?client=safari")!, children:[
            WebTab(title: "swiftu tree view - Пошук Google", url: URL(string:"https://www.google.com/search?client=safari&rls=en&q=swiftu+tree+view&ie=UTF-8&oe=UTF-8")!, children:[]),
        ])
        ]
}


extension WebTabsViewModel {
    static func previewModel() -> WebTabsViewModel {
        return WebTabsViewModel(tabs: WebTab.previewTabs)
    }
}
