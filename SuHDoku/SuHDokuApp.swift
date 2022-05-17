//
//  SuHDokuApp.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI
import GoogleMobileAds

@main
struct SuHDokuApp: App {
    
    // Initializer for the ads
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
