//
//  SidePanelView.swift
//  DataCollector
//
//  Created by standard on 3/9/23.
//

import Foundation
import SwiftUI

struct SidePanelView: View {
    @State
    var goTo: String = ""

    @EnvironmentObject
    var webTabsViewModel: WebTabsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                WebTabTreeView()
            }
            Spacer()
            TextField("url", text: $goTo)
                .onSubmit {
                    if let request = WebTabsViewModel.requestFrom(goTo) {
                        webTabsViewModel.openTab(request: request, fromTab: nil)
                        goTo = ""
                    }
                }
                .padding(5)
                .background(.white)
                .cornerRadius(7)
                .autocorrectionDisabled(true)

        }.adaptsToKeyboard()
    }
}

struct SidePanelView_Previews: PreviewProvider {
    static var previews: some View {
        SidePanelView()
            .environmentObject(WebTabsViewModel.previewModel())
    }
}
