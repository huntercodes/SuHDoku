//
//  Artist.swift
//  SpotifyUIKit
//
//  Created by hunter downey on 4/27/22.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
