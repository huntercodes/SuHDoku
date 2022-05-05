//
//  Fonts.swift
//  SuHDoku
//
//  Created by hunter downey on 5/4/22.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Font
extension UIFont {

    /// Package title label font
    public static var petTitle: UIFont = .init(
        name: .petahjaItalic,
        size: 36)!

    /// Package description label & package accessories label & price title label
    public static var petBody: UIFont = .init(
        name: .petahjaRegular,
        size: 26)!
}

// MARK: - Fonts
extension Font {

    /// Package title label font
    public static var petahjaTitle: Font {

        #if DEBUG
        if ProcessInfo.isPreview {

            return .system(size: 36, weight: .bold, design: .default)
        }
        #endif

        return Font.custom(.petahjaItalic, size: 36)
    }

    /// Package description label & package accessories label & price title label
    public static var petahjaBody: Font {

        #if DEBUG
        if ProcessInfo.isPreview {

            return .system(size: 26, weight: .medium, design: .default)
        }
        #endif

        return Font.custom(.petahjaRegular, size: 26)
    }
}

// MARK: - Font names
extension String {

    fileprivate static let petahjaItalic: String = "Petahja-Italic"
    fileprivate static let petahjaRegular: String = "Petahja-Regular"
}

extension ProcessInfo {

    static var isPreview: Bool {

        processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
