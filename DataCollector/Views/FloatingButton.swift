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
    let alignment: Alignment
    var body: some View {
        ZStack(alignment: alignment) {
            Spacer()
            Button(action: action) {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(30)
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        .ignoresSafeArea()
//        .padding(.bottom, 27)
//        .padding(.trailing, 1)
    }
}
