//
//  GameLayout.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct GameLayout: View {
    @EnvironmentObject var gm: GameManager
    @EnvironmentObject var gt: GameTimer
    
    var body: some View {
        GeometryReader { geometry in
            
            // Arrange puzzle and command bar vertically if there is more vertical space
            if geometry.size.height >= geometry.size.width {
                VStack {
                    Spacer()
                        .frame(maxHeight: 8)
                    
                    BannerAd(unitID: "ca-app-pub-2697499973921649/2238680136")
                        .padding(.top)
                        .frame(width: 320, height: 50)
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    BoardView()
                        .environmentObject(self.gm)
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    CommandBar()
                        .environmentObject(self.gm)
                }
            }
            
            // Arrange puzzle and command bar horizontally if there is more horizontal space
            else {
                VStack {
                    Spacer()
                    
                    HStack {
                        BoardView()
                            .environmentObject(self.gm)
                        
                        Spacer()
                            .frame(maxWidth: 8)
                        
                        VStack {
                            CommandBar()
                                .environmentObject(self.gm)
                            
                            Spacer()
                                .frame(maxHeight: 16)
                            
                            // Test Banner ID: ca-app-pub-3940256099942544/2934735716
                            // Created Game Banner ID: ca-app-pub-2697499973921649/2238680136
                            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                                .padding(.bottom)
                                .frame(width: 320, height: 50)
                        }
                    }
                
                }
            }
        }
    }
}

struct GameLayout_Previews: PreviewProvider {
    static var previews: some View {
        GameLayout()
            .environmentObject(GameManager(puzzleMode: .easy))
            .environmentObject(PreferencesManager())
            .previewInterfaceOrientation(.portrait)
        GameLayout()
            .environmentObject(GameManager(puzzleMode: .easy))
            .environmentObject(PreferencesManager())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
