//
//  TabTreeView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

struct WebTabTreeView: View {
    
    @State
    var webTabs: [WebTab]
    
    var body: some View {
        VStack {
            ForEach(webTabs) { tab in
                OutlineGroup(tab, children: \.children) { item in
                    Text("\(item.description)")
                }
            }
        }
        
    }
}




struct WebTabTreeView_Previews: PreviewProvider {
    static var previews: some View {
        WebTabTreeView(webTabs: WebTab.previewTabs)
    }
}
