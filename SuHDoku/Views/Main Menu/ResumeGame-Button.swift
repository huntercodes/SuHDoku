//
//  ResumeGame-Button.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct ResumeGameButton: View {
    @Binding var selectedPuzzleDifficulty: PuzzleMode?
    @Binding var canResume: Bool
    
    // Button to resume a previously started puzzle
    var body: some View {
        NavigationLink(destination: GameView(puzzleMode: PuzzleMode.resume, canResume: self.$canResume, selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty)) {
            HStack {
                Text("Resume Puzzle")
                    .font(Font.custom("Petahja-Regular", size: 28))
                    .frame(maxWidth: 150, maxHeight: .infinity)
                    .foregroundColor(Color("regularTextColor"))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor3"))
                        .frame(height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(height: 55)
                    )
                
                Spacer()
                    .frame(maxWidth: 120)
                    
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("regularTextColor"))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor3"))
                        .frame(width: 55, height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(width: 55, height: 55)
                    )
            }
            .frame(minWidth: 360)
        }
        .background(Ellipse()
            .fill(Color("mainColor1"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
        .overlay(Ellipse()
            .stroke(Color("regularTextColor"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
    }
}

struct ResumeGameButton_Previews: PreviewProvider {
    @State static var selectedPuzzleDifficulty: PuzzleMode? = PuzzleMode.menu
    @State static var canResume = false
    static var previews: some View {
        ResumeGameButton(selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty, canResume: $canResume)
    }
}
