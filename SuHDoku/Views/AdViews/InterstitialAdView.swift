//
//  InterstitialAdView.swift
//  SuHDoku
//
//  Created by hunter downey on 5/11/22.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final class InterstitialAdView: NSObject, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
        self.loadInterstitial()
    }
    
    func loadInterstitial() {
        let request = GADRequest()
        let interAd = "ca-app-pub-2697499973921649/6723901818"
        
        GADInterstitialAd.load(
            
            // Test Interstitial ID: ca-app-pub-3940256099942544/4411468910
            withAdUnitID: interAd,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                
                interstitial = ad
            }
        )
    }
    
    func showAd() {
        if self.interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            self.interstitial?.present(fromRootViewController: root!)
        } else {
            print("Not Ready")
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadInterstitial()
    }
    
}

