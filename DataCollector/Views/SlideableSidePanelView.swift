//
//  SlideableSidePanelView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct SlideableSidePanelView<Content: View>: View {
    @Binding var isSidebarVisible: Bool
    let content: () -> Content

    var sideBarWidth = UIScreen.main.bounds.size.width * 0.9
    var bgColor: Color = .white.opacity(0.96)

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }
            panelContent
        }
        .edgesIgnoringSafeArea(.all)
    }

    var panelContent: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgColor
                content()
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)

            Spacer()
        }
    }
}
