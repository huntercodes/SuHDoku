//
//  MainMenu.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct MainMenu: View {
    @State var selectedPuzzleDifficulty: PuzzleMode?
    @State var canResume: Bool
    @State var menuBanner = "ca-app-pub-2697499973921649/7587209739"
    @ObservedObject var trackingHelper = ATTrackingHelper()

    init() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["canResumePuzzle": false,
                                     "easyGamesCompleted": 0,
                                     "mediumGamesCompleted": 0,
                                     "hardGamesCompleted": 0,
                                     "easyTotalPuzzleTime": 0,
                                     "mediumTotalPuzzleTime": 0,
                                     "hardTotalPuzzleTime": 0,
                                     "easyFastestPuzzleTime": 362439,
                                     "mediumFastestPuzzleTime": 362439,
                                     "hardFastestPuzzleTime": 362439,
                                     "automaticallyClearPencilEntries": true,
                                     "highlightConflicts": true,
                                     "highlightLikeNumbers": true])
        
        self.selectedPuzzleDifficulty = .menu
        self.canResume = defaults.bool(forKey: "canResumePuzzle")
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    MainMenuLayout(selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty, canResume: self.$canResume)
                        .onAppear {
                            trackingHelper.requestAuth()
                        }
                    
                    // NavigationLink to start new easy game when selected by NewGameButton
                    NavigationLink(destination: GameView(puzzleMode: PuzzleMode.easy, canResume: self.$canResume, selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty), tag: PuzzleMode.easy, selection: self.$selectedPuzzleDifficulty) {}.foregroundColor(Color("regularTextColor"))
                    
                    // NavigationLink to start new medium game when selected by NewGameButton
                    NavigationLink(destination: GameView(puzzleMode: PuzzleMode.medium, canResume: self.$canResume, selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty), tag: PuzzleMode.medium, selection: self.$selectedPuzzleDifficulty) {}.foregroundColor(Color("regularTextColor"))
                    
                    // NavigationLink to start new hard game when selected by NewGameButton
                    NavigationLink(destination: GameView(puzzleMode: PuzzleMode.hard, canResume: self.$canResume, selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty), tag: PuzzleMode.hard, selection: self.$selectedPuzzleDifficulty) {}.foregroundColor(Color("regularTextColor"))
                    
                    BannerAd(unitID: menuBanner)
                        .padding(.bottom)
                        .frame(width: 320, height: 50)
                }
                .padding(10)
                .background(
                        LinearGradient(gradient: Gradient(
                            colors: [Color("backgroundColor"), Color("mainColor2")]),
                            startPoint: .top, endPoint: .bottom
                        )
                        .ignoresSafeArea()
                )
                .navigationTitle("SuHDoku")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color("regularTextColor"))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("mainColor1")))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("regularTextColor")))
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
