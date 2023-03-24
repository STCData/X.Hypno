//
//  CGGraphics+NaturalLanguage.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation

extension CGRect: NaturalLanguageDescribable {
    var naturalLanguageClass: String {
        "Rectangle"
    }

    var naturalLanguageDescription: String {
        "[[originX, originY], [width, height]]"
    }
}
