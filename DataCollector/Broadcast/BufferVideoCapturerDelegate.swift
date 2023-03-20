//
//  BufferVideoCapturerDelegate.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import CoreMedia
import CoreVideo
import Foundation

@objc
protocol BufferVideoCapturerDelegate: AnyObject {
    func capturer(_ capturer: BufferCapturer, didCapture cmBuffer: CMSampleBuffer)
    func capturer(_ capturer: BufferCapturer, didCapture cvBuffer: CVPixelBuffer,
                  timeStampNs: Int64)
}
