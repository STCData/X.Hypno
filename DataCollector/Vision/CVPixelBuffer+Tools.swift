//
//  CVPixelBuffer+Tools.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import CoreVideo
import Foundation

extension CVPixelBuffer {
    func resized(to size: CGSize) -> CVPixelBuffer? {
        let imageWidth = CVPixelBufferGetWidth(self)
        let imageHeight = CVPixelBufferGetHeight(self)
        let imageAspectRatio = CGFloat(imageWidth) / CGFloat(imageHeight)
        let targetAspectRatio = size.width / size.height

        var scaleX: CGFloat
        var scaleY: CGFloat

        if targetAspectRatio > imageAspectRatio {
            scaleX = size.height * imageAspectRatio
            scaleY = size.height
        } else {
            scaleX = size.width
            scaleY = size.width / imageAspectRatio
        }

        let pixelBufferWidth = Int(scaleX)
        let pixelBufferHeight = Int(scaleY)

        var pixelBuffer: CVPixelBuffer?
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferWidthKey as String: pixelBufferWidth,
            kCVPixelBufferHeightKey as String: pixelBufferHeight,
        ]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         pixelBufferWidth,
                                         pixelBufferHeight,
                                         CVPixelBufferGetPixelFormatType(self),
                                         options as CFDictionary,
                                         &pixelBuffer)

        guard let outputPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        CVPixelBufferLockBaseAddress(outputPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        let inputPlaneCount = CVPixelBufferGetPlaneCount(self)
        let outputPlaneCount = CVPixelBufferGetPlaneCount(outputPixelBuffer)

        for plane in 0 ..< min(inputPlaneCount, outputPlaneCount) {
            let inputPlane = CVPixelBufferGetBaseAddressOfPlane(self, plane)
            let outputPlane = CVPixelBufferGetBaseAddressOfPlane(outputPixelBuffer, plane)

            let inputBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(self, plane)
            let outputBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(outputPixelBuffer, plane)

            let inputPlaneHeight = CVPixelBufferGetHeightOfPlane(self, plane)
            let outputPlaneHeight = CVPixelBufferGetHeightOfPlane(outputPixelBuffer, plane)

            let bytesPerPixel = 4 // assuming 32-bit RGBA
            for y in 0 ..< outputPlaneHeight {
                let inputRow = Int(Double(y) / Double(outputPlaneHeight) * Double(inputPlaneHeight))
                let inputOffset = inputRow * inputBytesPerRow
                let outputOffset = y * outputBytesPerRow
                memcpy(outputPlane?.advanced(by: outputOffset), inputPlane?.advanced(by: inputOffset), outputBytesPerRow)
            }
        }

        CVPixelBufferUnlockBaseAddress(outputPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

        return outputPixelBuffer
    }
}
