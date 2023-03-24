//
//  FloatingButton.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

private let defaultOpacity = 0.3

struct TapAndLongPressModifier: ViewModifier {
    @State private var isLongPressing = false
    let tapAction: () -> Void
    let longPressAction: () -> Void
    func body(content: Content) -> some View {
        content
            .scaleEffect(isLongPressing ? 1.7 : 1.0)
            .onLongPressGesture(minimumDuration: 1.0, pressing: { isPressing in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isLongPressing = isPressing
//                    print(isPressing)
                }
            }, perform: {
                longPressAction()
            })
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        tapAction()
                    }
            )
    }
}

struct FloatingButton: View {
    var action: () -> Void = {}
    var longTapAction: () -> Void = {}
    let icon: String
    var width: Double = 39
    var height: Double = 34
    var iconSize: Double = 25
    var cornerRadius: Double = 4

    var color: Color = .white.opacity(defaultOpacity)
    static let brightColor: Color = .white.opacity(defaultOpacity * 2)
    static let enabledColor: Color = .white.opacity(defaultOpacity)
    static let disabledColor: Color = .black.opacity(defaultOpacity)
    static let recColor: Color = .red.opacity(defaultOpacity)
    var body: some View {
//        ZStack {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(color)
                .frame(width: width, height: height)

                .modifier(TapAndLongPressModifier(tapAction: { self.action() },
                                                  longPressAction: { self.longTapAction() }))
        }
        .background(Color.gray.opacity(defaultOpacity / 4))
        .cornerRadius(cornerRadius)
//        }

//        .shadow(radius: 10)
    }
}

struct FloatingAtCorner<Content: View>: View {
    let alignment: Alignment
    let content: () -> Content

    var body: some View {
        ZStack(alignment: alignment) {
            Spacer()
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        .padding(.top, 32)
        .padding(.bottom, 32)
        .padding(.trailing, 4)

        .ignoresSafeArea()
    }
}
