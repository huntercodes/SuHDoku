//
//  NumberBar.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct NumberBar: View {
    @EnvironmentObject var gm: GameManager
    
    // A view composed of 9 NumberInput views to represent each number used in a sudoku puzzle
    var body: some View {
        HStack() {
            ForEach(1...9, id: \.self) { num in
                NumberInput(number: num)
                    .frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 0, maxHeight: .infinity)
                    .aspectRatio(0.5, contentMode: .fit)
            }
        }
    }
}

struct NumberBar_Previews: PreviewProvider {
    static var previews: some View {
        NumberBar()
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
    }
}
