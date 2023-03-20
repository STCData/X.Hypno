//
//  FloatingButton.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct FloatingButton: View {
    let action: () -> Void
    let icon: String
    var color: Color = .white
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(color)
        }
        .frame(width: 60, height: 60)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(30)
        .shadow(radius: 10)
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
        .padding(.bottom, 28)
        .padding(.trailing, 4)

        .ignoresSafeArea()
    }
}
