//
//  SettingsView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var preferencesManager: PreferencesManager
    
    @State var automaticallyClearPencilEntries: Bool = true
    @State var highlightConflicts: Bool = true
    @State var highlightLikeNumbers: Bool = true
    
    // A function to store preference values
    func savePreferences() {
        self.preferencesManager.automaticallyClearPencilEntries = self.automaticallyClearPencilEntries
        self.preferencesManager.highlightConflicts = self.highlightConflicts
        self.preferencesManager.highlightLikeNumbers = self.highlightLikeNumbers
        
        self.preferencesManager.writePreferences()
    }
    
    // A list of toggles to set user preferences for sudoku
    var body: some View {
        VStack {
            List {
                Toggle("Automatically Clear Pencil Entries", isOn: self.$automaticallyClearPencilEntries)
                    .font(Font.custom("Petahja-Regular", size: 20))
                    .foregroundColor(Color("mainColor4"))
                
                Toggle("Highlight Conflicts", isOn: self.$highlightConflicts)
                    .font(Font.custom("Petahja-Regular", size: 20))
                    .foregroundColor(Color("mainColor5"))
                
                Toggle("Highlight Like Numbers", isOn: self.$highlightLikeNumbers)
                    .font(Font.custom("Petahja-Regular", size: 20))
                    .foregroundColor(Color("mainColor6"))
            }
            
            // Update the appearance of toggles based on user preferences when view loads
            .onAppear(perform: {
                self.automaticallyClearPencilEntries = self.preferencesManager.automaticallyClearPencilEntries
                self.highlightConflicts = self.preferencesManager.highlightConflicts
                self.highlightLikeNumbers = self.preferencesManager.highlightLikeNumbers
            })
            
            // Save preferences when the view disappears
            .onDisappear(perform: {
                self.savePreferences()
            })
            
            // Save preferences when the view is no longer active
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.savePreferences()
            }
            
            .background(Color("backgroundColor").ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PreferencesManager())
    }
}
