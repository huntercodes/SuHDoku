//
//  ThreeByThreeView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct ThreeByThreeView: View {
    @EnvironmentObject var gm: GameManager
    
    var rowMin: Int
    var rowMax: Int
    var colMin: Int
    var colMax: Int
    
    // 3 by 3 subgrid composed of 9 regular cells
    var body: some View {
        VStack(spacing: 0) {
            ForEach(rowMin...rowMax, id: \.self) { rowNum in
                HStack(spacing: 0) {
                    CellView(row: rowNum, col: colMin+0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                    CellView(row: rowNum, col: colMin+1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                    CellView(row: rowNum, col: colMin+2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .padding(1.5)
        .border(Color("regularTextColor"), width:1.5)
    }
}

struct ThreeByThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeByThreeView(rowMin: 0, rowMax: 2, colMin: 0, colMax: 2)
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
            .environmentObject(PreferencesManager())
    }
}
