//
//  BoardView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var gm: GameManager
    
    // Puzzle board composed of 9 subgrids in a 3 by 3 arrangement
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...2, id: \.self) { blockRow in
                HStack(spacing: 0) {
                    ForEach(0...2, id: \.self) { blockCol in
                        ThreeByThreeView(rowMin: blockRow*3, rowMax: blockRow*3+2, colMin: blockCol*3, colMax: blockCol*3+2)
                    }
                }
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
            .environmentObject(PreferencesManager())
    }
}
