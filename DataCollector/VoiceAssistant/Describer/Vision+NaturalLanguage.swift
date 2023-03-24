//
//  Vision+NaturalLanguage.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation

import Vision

extension VNRecognizedPointKey: NaturalLanguageDescribable {
    var naturalLanguageClass: String {
        "String"
    }

    var naturalLanguageDescription: String {
        "String"
    }
}
