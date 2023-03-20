//
//  VisionMarkerView.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation

import SwiftUI

enum VisionMarkerViewType {
    case redBold
    case greenThin
}

struct VisionMarkerView: View {
    var type: VisionMarkerViewType
    var body: some View {
        switch type {
        case .redBold:
            Rectangle()
                .stroke(lineWidth: 2)
                .foregroundColor(.red)
        case .greenThin:
            Rectangle()
                .stroke(lineWidth: 0.3)
                .foregroundColor(.green.opacity(0.5))
                .background(.green.opacity(0.04))
        }
    }
}
