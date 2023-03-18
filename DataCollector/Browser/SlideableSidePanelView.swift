//
//  SlideableSidePanelView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct SlideableSidePanelView: View {
    @Binding var isSidebarVisible: Bool

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
            content
        }
        .edgesIgnoringSafeArea(.all)
    }

    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgColor
                SidePanelView()
                    .padding(EdgeInsets(top: 60, leading: 2, bottom: 2, trailing: 2))
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)

            Spacer()
        }
    }
}
