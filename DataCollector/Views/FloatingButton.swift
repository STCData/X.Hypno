//
//  FloatingButton.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

private let defaultOpacity = 0.3

struct FloatingButton: View {
    let action: () -> Void
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
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(color)
        }
        .frame(width: width, height: height)
        .background(Color.gray.opacity(defaultOpacity / 4))
        .cornerRadius(cornerRadius)
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
