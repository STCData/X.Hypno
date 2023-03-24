//
//  ObservationPoint+NaturalLanguage.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation

extension ObservationPoint: NaturalLanguageDescribable {
    var naturalLanguageClass: String {
        "Point"
    }

    var naturalLanguageDescription: String {
        "x, y, optional 'identifier'"
    }
}
