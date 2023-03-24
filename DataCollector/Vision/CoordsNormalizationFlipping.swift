//
//  CoordsNormalizationFlipping.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation

import Vision

func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}

func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}
