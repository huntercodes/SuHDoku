//
//  ATTRequestView.swift
//  SuHDoku
//
//  Created by hunter downey on 5/31/22.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import UIKit

class ATTrackingHelper: ObservableObject {
    @Published var currentStatus = ATTrackingManager.trackingAuthorizationStatus
    @Published var currentUUID = ASIdentifierManager.shared().advertisingIdentifier

    func requestAuth() {
        guard ATTrackingManager.trackingAuthorizationStatus != .authorized else {
            return
        }
        
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async { [self] in
                currentStatus = status
                if status == .authorized {
                    self.currentUUID = ASIdentifierManager.shared().advertisingIdentifier
                }
            }
        }
    }
}
