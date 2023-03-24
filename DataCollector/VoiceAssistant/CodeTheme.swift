//
//  CodeTheme.swift
//  DataCollector
//
//  Created by standard on 3/24/23.
//

import Foundation

import UIKit

import Runestone

class CodeTheme: Runestone.Theme {
    private init() {}

    static let shared = CodeTheme()

    var font: UIFont {
        return UIFont(name: "Menlo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }

    var textColor: UIColor {
        return UIColor.white
    }

    var gutterBackgroundColor: UIColor {
        return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }

    var gutterHairlineColor: UIColor {
        return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    }

    var gutterHairlineWidth: CGFloat {
        return 1.0
    }

    var lineNumberColor: UIColor {
        return UIColor.lightGray
    }

    var lineNumberFont: UIFont {
        return UIFont(name: "CourierNewPS-BoldItalicMT", size: 7) ?? UIFont.systemFont(ofSize: 7)
    }

    var selectedLineBackgroundColor: UIColor {
        return UIColor(red: 0.35, green: 0.25, blue: 0.15, alpha: 1.0)
    }

    var selectedLinesLineNumberColor: UIColor {
        return UIColor.white
    }

    var selectedLinesGutterBackgroundColor: UIColor {
        return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }

    var invisibleCharactersColor: UIColor {
        return UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }

    var pageGuideHairlineColor: UIColor {
        return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    }

    var pageGuideBackgroundColor: UIColor {
        return UIColor.clear
    }

    var markedTextBackgroundColor: UIColor {
        return UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    }

    var markedTextBackgroundCornerRadius: CGFloat {
        return 5.0
    }

    func textColor(for highlightName: String) -> UIColor? {
        switch highlightName {
        case "keyword":
            return UIColor(red: 0.69, green: 0.89, blue: 0.69, alpha: 1.0)
        case "string":
            return UIColor(red: 0.91, green: 0.86, blue: 0.68, alpha: 1.0)
        case "comment":
            return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        default:
            return nil
        }
    }

    func font(for highlightName: String) -> UIFont? {
        switch highlightName {
        case "keyword":
            return UIFont.boldSystemFont(ofSize: 14)
        default:
            return nil
        }
    }

    func fontTraits(for highlightName: String) -> FontTraits {
        switch highlightName {
        case "keyword":
            return [.bold]
        default:
            return []
        }
    }

    func shadow(for _: String) -> NSShadow? {
        return nil
    }
}
