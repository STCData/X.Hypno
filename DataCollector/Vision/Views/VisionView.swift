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

    func positionMarkerView(normalizedRect: CGRect, in geometry: GeometryProxy, content: () -> some View) -> some View {
        let rect = visionViewModel.deNormalize(normalizedRect, geometry)

        return content()
            .frame(width: rect.width, height: rect.height)
            // Changed to position
            // Adjusting for center vs leading origin
            .position(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(visionViewModel.objects, id: \.uuid) { object in
                    positionMarkerView(normalizedRect: object.boundingBox, in: geometry) {
                        VisionMarkerView(type: .redBold)
                    }
                }

                ForEach(visionViewModel.text, id: \.uuid) { txt in
                    positionMarkerView(normalizedRect: txt.boundingBox, in: geometry) {
                        VisionMarkerView(type: .greenThin)
                    }
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
