//
//  VisionView.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation

import SwiftUI

struct VisionView: View {
    @StateObject var visionViewModel: VisionViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(visionViewModel.objects, id: \.uuid) { object in
                    let rect = visionViewModel.deNormalize(object.boundingBox, geometry)
                    Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.red)
                        .frame(width: rect.width, height: rect.height)
                        // Changed to position
                        // Adjusting for center vs leading origin
                        .position(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
                }

                ForEach(visionViewModel.text, id: \.uuid) { txt in
                    let rect = visionViewModel.deNormalize(txt.boundingBox, geometry)
                    Rectangle()
                        .stroke(lineWidth: 0.3)
                        .foregroundColor(.green.opacity(0.5))
                        .background(.green.opacity(0.04))
                        .frame(width: rect.width, height: rect.height)
                        // Changed to position
                        // Adjusting for center vs leading origin
                        .position(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
                }
            }
            // Geometry reader makes the view shrink to its smallest size
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Flip upside down
            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
        }
//        .border(Color.orange)
    }
}
