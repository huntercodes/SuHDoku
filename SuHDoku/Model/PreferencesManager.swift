//
//  PreferencesManager.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation
import SwiftUI

// Object used to handle storage of user preferences
class PreferencesManager: ObservableObject {
    
    // Current values of all user preferences
    @Published var automaticallyClearPencilEntries: Bool
    @Published var highlightConflicts: Bool
    @Published var highlightLikeNumbers: Bool
    
    init() {
        self.automaticallyClearPencilEntries = true
        self.highlightConflicts = true
        self.highlightLikeNumbers = true
        
        self.readPreferences()
    }
    
    // Read all preferences from storage
    func readPreferences() {
        let defaults = UserDefaults.standard
        
        self.automaticallyClearPencilEntries = defaults.bool(forKey: "automaticallyClearPencilEntries")
        self.highlightConflicts = defaults.bool(forKey: "highlightConflicts")
        self.highlightLikeNumbers = defaults.bool(forKey: "highlightLikeNumbers")
    }
    
    // Write current user preferences to storage
    func writePreferences() {
        let defaults = UserDefaults.standard
        
        defaults.set(self.automaticallyClearPencilEntries, forKey: "automaticallyClearPencilEntries")
        defaults.set(self.highlightConflicts, forKey: "highlightConflicts")
        defaults.set(self.highlightLikeNumbers, forKey: "highlightLikeNumbers")
    }
}
