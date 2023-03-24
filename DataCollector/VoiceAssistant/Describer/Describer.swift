//
//  Describer.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Combine
import Foundation

class Describer: Subscriber {
    var classDescriptions = [
        String: String
    ]()

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }

    typealias Input = NaturalLanguageDescribable

    typealias Failure = Never

    func receive(_ input: NaturalLanguageDescribable) -> Subscribers.Demand {
        let typeName = input.naturalLanguageClass

        if !classDescriptions.keys.contains(typeName) {
            classDescriptions[typeName] = input.naturalLanguageDescription
        }

        return .max(1)
    }

    func receive(completion _: Subscribers.Completion<Never>) {}

    static var shared = Describer()

    private init() {}
}

func NaturalLanguageDescribe<T>(_ value: T) -> String? {
    let mirror = Mirror(reflecting: value)
    var description = ""

    if let displayStyle = mirror.displayStyle {
        switch displayStyle {
        case .struct, .class:
            for child in mirror.children {
                if let label = child.label {
                    let nestedValue = child.value
                    if let nestedDescription = NaturalLanguageDescribe(nestedValue) {
                        description += "\(label): \(nestedDescription), "
                    } else {
                        description += "\(label): \(type(of: nestedValue)), "
                    }
                }
            }
            if description.hasSuffix(", ") {
                description.removeLast(2)
            }
            return "{\(description)}"

        case .collection:
            var typeName = String(describing: type(of: value))
            if typeName.hasPrefix("_") {
                typeName = String(typeName.dropFirst())
            }
            return "\(typeName)<\(mirror.children.first.map { type(of: $0.value) } ?? Any.Type.self)>"

        default:
            return String(describing: value)
        }
    }

    return nil
}
