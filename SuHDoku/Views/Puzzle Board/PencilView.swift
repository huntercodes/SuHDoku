//
//  PencilView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct PencilView: View {
    @EnvironmentObject var gm: GameManager
    var row: Int
    var col: Int
    
    // View used to display pencil entries with a cell on the sudoku board
    var body: some View {
        let pencilDisplay = """
        \(gm.puzzle.boardPencil[row][col][0] ? "1" : " ") \(gm.puzzle.boardPencil[row][col][1] ? "2" : " ") \(gm.puzzle.boardPencil[row][col][2] ? "3" : " ")
        \(gm.puzzle.boardPencil[row][col][3] ? "4" : " ") \(gm.puzzle.boardPencil[row][col][4] ? "5" : " ") \(gm.puzzle.boardPencil[row][col][5] ? "6" : " ")
        \(gm.puzzle.boardPencil[row][col][6] ? "7" : " ") \(gm.puzzle.boardPencil[row][col][7] ? "8" : " ") \(gm.puzzle.boardPencil[row][col][8] ? "9" : " ")
        """
        
        Text(pencilDisplay)
            .font(Font.custom("Petahja-Regular", size: 14))
            .foregroundColor(Color("regularTextColor"))
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .lineLimit(3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PencilView_Previews: PreviewProvider {
    static var previews: some View {
        PencilView(row: 0, col: 0)
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
            .aspectRatio(1.0, contentMode: .fit)
    }
}
