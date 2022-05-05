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
                    BoardView()
                        .environmentObject(self.gm)
                    Spacer()
                    CommandBar()
                        .environmentObject(self.gm)
                    Spacer()
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
                        CommandBar()
                            .environmentObject(self.gm)
                    }
                    Spacer()
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
