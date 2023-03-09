//
//  TabTreeView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

struct WebTabTreeView: View {
    
    @EnvironmentObject
    var webTabsViewModel: WebTabsViewModel

    var body: some View {
        VStack {
            ForEach(webTabsViewModel.tabs) { tab in
                OutlineGroup(tab, children: \.children) { item in
                    Text("\(item.description)")
                }
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
