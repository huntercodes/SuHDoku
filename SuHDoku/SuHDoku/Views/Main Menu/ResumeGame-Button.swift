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
                
                Spacer()
                    .frame(maxWidth: 150)
                    
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color("regularTextColor"))
            }
            .padding(15)
        }
        .cornerRadius(15)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("mainColor2")))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("regularTextColor")))
    }
}

struct ResumeGameButton_Previews: PreviewProvider {
    @State static var selectedPuzzleDifficulty: PuzzleMode? = PuzzleMode.menu
    @State static var canResume = false
    static var previews: some View {
        ResumeGameButton(selectedPuzzleDifficulty: self.$selectedPuzzleDifficulty, canResume: $canResume)
    }
}
