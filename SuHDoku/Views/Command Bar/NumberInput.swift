//
//  NumberInput.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct NumberInput: View {
    @EnvironmentObject var gm: GameManager
    @EnvironmentObject var preferencesManager: PreferencesManager
    var number: Int
    
    // Button to represent a single numerical entry key for a puzzle
    var body: some View {
        Button(action: {
            gm.updateCellValue(value: number, clearPencilEntries: self.preferencesManager.automaticallyClearPencilEntries)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).stroke(Color("regularTextColor"), lineWidth: 3)
                    .aspectRatio(0.5, contentMode: .fit)
                    .scaledToFill()
                
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(0.5, contentMode: .fit)
                    .scaledToFill()
                    .foregroundColor(Color("mainColor2"))
                
                Text(String(number))
                    .font(Font.custom("Petahja-Regular", size: 46))
                    .scaledToFit()
                    .foregroundColor(Color("regularTextColor"))
            }
        }
    }

}

struct NumberInput_Previews: PreviewProvider {
    static var previews: some View {
        NumberInput(number: 5)
            .frame(width: 30, height: 60)
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
    }
}
