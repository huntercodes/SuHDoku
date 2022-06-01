//
//  SettingsModel.swift
//  SpotifyUIKit
//
//  Created by hunter downey on 5/2/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
