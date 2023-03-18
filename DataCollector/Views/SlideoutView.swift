//
//  SlideableSidePanelView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct SlideoutView<Content: View>: View {
    var horizontal: Bool = true
    @Binding var isSidebarVisible: Bool
    let content: () -> Content

    var sideBarWidth = UIScreen.main.bounds.size.width * 0.9
    var sideBarHeight = UIScreen.main.bounds.size.height * 0.4
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
            let layout = horizontal ?
                AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

            layout {
                ZStack(alignment: .top) {
                    bgColor
                    content()
                }
                .if(horizontal) {
                    $0
                        .frame(width: sideBarWidth)
                        .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
                }
                .if(!horizontal) {
                    $0
                        .frame(height: sideBarHeight)
                        .offset(y: isSidebarVisible ? 0 : UIScreen.main.bounds.size.height)
                }

                .animation(.default, value: isSidebarVisible)

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
