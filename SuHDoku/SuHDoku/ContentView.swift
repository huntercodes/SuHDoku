//
//  ContentView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var preferencesManager = PreferencesManager()
    
    var body: some View {
        MainMenu()
            .environmentObject(preferencesManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
