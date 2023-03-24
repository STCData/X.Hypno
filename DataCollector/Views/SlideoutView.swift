//
//  SlideableSidePanelView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

private let animationDuration = 0.07

struct SlideoutView<Content: View>: View {
    var horizontal: Bool = true
    var opacity: Double
    @Binding var isSidebarVisible: Bool
    #if os(iOS)
        var sideBarWidth = UIScreen.main.bounds.size.width * 0.9
        var sideBarHeight = UIScreen.main.bounds.size.height * 0.4
    #else
        var sideBarWidth = 100.0
        var sideBarHeight = 500.0

    #endif
    var bgColor: Color
    var shadowColor: Color
    let content: () -> Content

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(shadowColor)
            .opacity(isSidebarVisible ? opacity : 0)
            .animation(.easeInOut.delay(animationDuration / 10), value: isSidebarVisible)
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
                    #if os(iOS)
                        .offset(y: isSidebarVisible ? 0 : -UIScreen.main.bounds.size.height)
                    #endif
                }

                .animation(.easeInOut(duration: animationDuration), value: isSidebarVisible)

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
