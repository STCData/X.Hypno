//
//  CVPixelBuffer+AlmostEqual.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//
import CoreVideo

extension CVPixelBuffer {
    func isAlmostEqual(to another: CVPixelBuffer) -> Bool {
        let old = self
        let new = another
        CVPixelBufferLockBaseAddress(old, .readOnly)
        CVPixelBufferLockBaseAddress(new, .readOnly)
        let oldP = CVPixelBufferGetBaseAddress(old)
        let newP = CVPixelBufferGetBaseAddress(new)

        let oldBuf = unsafeBitCast(oldP, to: UnsafeMutablePointer<UInt8>.self)
        let newBuf = unsafeBitCast(newP, to: UnsafeMutablePointer<UInt8>.self)

        let oldLen = CVPixelBufferGetDataSize(old)
        let newLen = CVPixelBufferGetDataSize(new)

        var isEqual = (oldLen == newLen)

        var differentBytes = 0
        let differentBytesTreshold = newLen / 100

        if oldLen == newLen && oldLen > 0 {
            for i in 0 ..< oldLen {
                if oldBuf[i] != newBuf[i] {
                    differentBytes += 1
                    if differentBytes >= differentBytesTreshold {
                        isEqual = false
                        break
                    }
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(old, .readOnly)
        CVPixelBufferUnlockBaseAddress(new, .readOnly)

        return isEqual
    }
}
