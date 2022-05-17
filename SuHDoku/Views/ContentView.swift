//
//  ContentView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var preferencesManager = PreferencesManager()
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        
        coloredAppearance.backgroundColor = UIColor(Color("mainColor2"))
        coloredAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color("regularTextColor")),
            .font: UIFont(name: "Petahja-Regular",
            size: 30)!
        ]
        
        UINavigationBar.appearance().tintColor = UIColor(Color("regularTextColor"))
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    var body: some View {
        MainMenu()
            .environmentObject(preferencesManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
