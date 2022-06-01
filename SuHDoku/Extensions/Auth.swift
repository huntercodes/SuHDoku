//
//  Auth.swift
//  SuHDoku
//
//  Created by hunter downey on 5/23/22.
//

import Foundation
import AppTrackingTransparency
import AdSupport

class Auth: ObservableObject {
    @Published var authStatus = ATTrackingManager.trackingAuthorizationStatus
}
