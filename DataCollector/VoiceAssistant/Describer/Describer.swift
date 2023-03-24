//
//  Describer.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Combine
import Foundation

class Describer: Subscriber {
    var allClassesNamesNaturalLanguage: String {
        classDescriptions.keys.joined(separator: ", ")
    }

    var allClassesNaturalLanguage: String {
        var output = ""
        for (key, value) in classDescriptions {
            output += "\(key):\n"
            let indentedValue = value.replacingOccurrences(of: "\n", with: "\n ")
            output += " \(indentedValue)\n\n"
        }

        return output
    }

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

//        print(classDescriptions)
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
                    if let nestedDescribable = nestedValue as? NaturalLanguageDescribable {
                        description += "\(label): \(nestedDescribable.naturalLanguageDescription), "
                    } else if let nestedDescription = NaturalLanguageDescribe(nestedValue) {
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
            let firstElementDescription: String
            if let firstElement = mirror.children.first?.value {
                if let describable = firstElement as? NaturalLanguageDescribable {
                    firstElementDescription = describable.naturalLanguageDescription
                } else {
                    firstElementDescription = NaturalLanguageDescribe(firstElement) ?? "\(type(of: firstElement))"
                }
            } else {
                firstElementDescription = "\(Any.Type.self)"
            }
            return "\(typeName)<\(firstElementDescription)>"

        case .dictionary:

            var keyType = "\(Any.Type.self)"
            var valueType = "\(Any.Type.self)"
            if let firstElement = mirror.children.first,
               let (key, value) = firstElement.value as? (Any, Any)
            {
                if let describableKey = key as? NaturalLanguageDescribable {
                    keyType = describableKey.naturalLanguageDescription
                } else {
                    keyType = String(describing: type(of: key))
                }

                if let describableValue = value as? NaturalLanguageDescribable {
                    valueType = describableValue.naturalLanguageDescription
                } else {
                    valueType = String(describing: type(of: value))
                }
            }
            return "{ \(keyType) : \(valueType) }"

        default:
            return String(describing: value)
        }
    }

    return nil
}
