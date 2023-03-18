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
    var body: some View {
        VStack {
            Spacer()
            HStack {
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
                .offset(x: -1, y: 27)
            }
        }
    }
}
