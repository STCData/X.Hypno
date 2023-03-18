//
//  TabTreeView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

struct NodeOutlineGroup<Node, Content>: View where Node: Hashable, Node: Identifiable, Node: CustomStringConvertible, Content: View {
    let node: Node
    let childKeyPath: KeyPath<Node, [Node]?>
    @State var isExpanded: Bool = true
    let content: (Node) -> Content

    var body: some View {
        if node[keyPath: childKeyPath] != nil {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    if isExpanded {
                        ForEach(node[keyPath: childKeyPath]!) { childNode in
                            HStack {
                                Spacer()
                                    .frame(width: 10)
                                NodeOutlineGroup(node: childNode, childKeyPath: childKeyPath, isExpanded: isExpanded, content: content)
                            }
                        }
                    }
                },
                label: { content(node) }
            )
        } else {
            content(node)
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
                NodeOutlineGroup(node: tab, childKeyPath: \.children, isExpanded: true) { node in
                    Text(node.description)
                        .onTapGesture {
                            webTabsViewModel.selectTab(node)
                        }
                }
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
