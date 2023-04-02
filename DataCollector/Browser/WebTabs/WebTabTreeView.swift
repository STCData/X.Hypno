//
//  TabTreeView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

struct WebTabTreeItemInner: View {
    let faviconSize = 16.0
    @EnvironmentObject
    var webTabsViewModel: WebTabsViewModel

    @ObservedObject
    var tab: WebTab

    var body: some View {
        HStack {
            if let image = tab.faviconImage {
                Image(uiImage: image)
                    .resizable()
                    .if(tab.faviconColorTint != nil) {
                        $0.renderingMode(.template)
                            .foregroundColor(tab.faviconColorTint)
                    }
                    .frame(width: faviconSize, height: faviconSize)
            }
            Text((tab.title ?? tab.urlRequest.url?.absoluteString) ?? "<<na>>")
                .minimumScaleFactor(0.4)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(3)
        .if(tab == webTabsViewModel.currentTab) { $0.background(Color(uiColor: .systemGray6))
        }
        .cornerRadius(4)
        .onTapGesture {
            webTabsViewModel.selectTab(tab)
        }
    }
}




struct WebTabTreeItem: View {
    @State var isExpanded: Bool = true

    @EnvironmentObject var webTabsViewModel: WebTabsViewModel
    @ObservedObject
    var tab: WebTab

    let childKeyPath: KeyPath<WebTab, [WebTab]?>

    var body: some View {
        if tab[keyPath: childKeyPath] != nil {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    ForEach(tab[keyPath: childKeyPath]!) { childNode in
                        HStack {
                            Spacer().frame(width: 10)
                            WebTabTreeItem(tab: childNode, childKeyPath: childKeyPath)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                },
                label: {
                    WebTabTreeItemInner(tab: tab)
                }
            )
            .tint(.black)

        } else {
            WebTabTreeItemInner(tab: tab)
        }
    }
}

struct WebTabTreeView: View {
    @EnvironmentObject
    var webTabsViewModel: WebTabsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(webTabsViewModel.tabs) { tab in
//                List {
                WebTabTreeItem(tab: tab, childKeyPath: \.children)
//                }
            }
        }
    }
}

struct WebTabTreeView_Previews: PreviewProvider {
    static var previews: some View {
        WebTabTreeView()
            .environmentObject(WebTabsViewModel.previewModel())
    }
}
