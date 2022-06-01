//
//  SuHDokuApp.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
struct SuHDokuApp: App {
    @ObservedObject var trackingHelper = ATTrackingHelper()
    
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
