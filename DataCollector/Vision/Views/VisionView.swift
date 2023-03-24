//
//  VisionView.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation

import SwiftUI
import Vision

struct VisionView: View {
    @StateObject var visionViewModel: VisionViewModel

    func positionMarkerView(normalizedRect: CGRect, in geometry: GeometryProxy, content: () -> some View) -> some View {
        let rect = DenormalizedRect(normalizedRect, forSize: geometry.size)

        return content()
            .frame(width: rect.width, height: rect.height)
            // Changed to position
            // Adjusting for center vs leading origin
            .position(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
    }

    func positionMarkerView(normalizedPoint: VNPoint, in geometry: GeometryProxy, content: () -> some View) -> some View {
        let point = DenormalizedPoint(CGPoint(x: normalizedPoint.x, y: normalizedPoint.y), forSize: geometry.size)

        return content()
            // Changed to position
            // Adjusting for center vs leading origin
            .position(x: point.x, y: point.y)
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

                ForEach(visionViewModel.hands, id: \.uuid) { hand in
                    ForEach(hand.availableJointNames, id: \.self) { joint in
                        if let point = try? hand.recognizedPoint(joint) {
                            positionMarkerView(normalizedPoint: point, in: geometry) {
                                VisionMarkerView(type: .yellowCicle)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                }

                ForEach(visionViewModel.humanBodyPoses, id: \.uuid) { pose in
                    ForEach(pose.availableJointNames, id: \.self) { joint in
                        if let point = try? pose.recognizedPoint(joint) {
                            positionMarkerView(normalizedPoint: point, in: geometry) {
                                VisionMarkerView(type: .yellowCicle)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                }

                VAWebView(observationPublisher: visionViewModel.cleanedObservationsPublisher)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
//                    .border(Color.green)
            }
            // Geometry reader makes the view shrink to its smallest size
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
//        .frame(maxWidth:.infinity, maxHeight:.infinity)
//        .ignoresSafeArea()
    }
}
