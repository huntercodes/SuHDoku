//
//  NewReleasesResponse.swift
//  SpotifyUIKit
//
//  Created by hunter downey on 5/25/22.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}
