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
    @Binding var isSidebarVisible: Bool

    @FocusState var isTextFieldFocused: Bool

    @EnvironmentObject
    var webTabsViewModel: WebTabsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                WebTabTreeView()
            }
            Spacer()
            TextField("url", text: $goTo)
                .keyboardType(.URL)
                .autocorrectionDisabled(true)
                .onSubmit {
                    if let request = WebTabsViewModel.requestFrom(goTo) {
                        webTabsViewModel.openTab(request: request, fromTab: nil)
                        goTo = ""
                        isSidebarVisible = false
                    }
                }
                .padding(5)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(7)
                .autocorrectionDisabled(true)
                .focused($isTextFieldFocused)
                .onChange(of: isSidebarVisible) { newValue in
                    if newValue {
                        isTextFieldFocused = true
                    }
                }
        }
        .adaptsToKeyboard()
    }
}

struct SidePanelView_Previews: PreviewProvider {
    @State
    static var isSidebarVisible = true
    static var previews: some View {
        SidePanelView(isSidebarVisible: $isSidebarVisible)
            .environmentObject(WebTabsViewModel.previewModel())
    }
}
