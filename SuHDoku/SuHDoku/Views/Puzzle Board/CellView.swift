//
//  CellView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct CellView: View {
    @EnvironmentObject var gm: GameManager
    @EnvironmentObject var preferencesManager: PreferencesManager
    var row: Int
    var col: Int
    var subgrid: Int
    
    // Custom button style to prevent appearance of a pushed button on cell
    struct cellButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(configuration.isPressed ? Color.black : Color.black)
        }
    }
    
    // Cell text color depending on user preference for highlighting like numbers
    var cellTextColor: Color {
        if self.preferencesManager.highlightLikeNumbers && self.gm.cellSelected && self.gm.selectedValue == self.gm.puzzle.board[row][col] { return Color("selectedCellBorder") }
        else { return gm.puzzle.boardLocked[row][col] ? Color("regularTextColor") : Color.gray }
    }
    
    // Cell border color depending on whether the cell is currently selected
    var cellBorderColor: Color {
        return(gm.selectedRow == row && gm.selectedCol == col && gm.cellSelected) ? Color("selectedCellBorder") : Color("regularTextColor")
    }
    
    // Cell border width depending on whether the cell is currently selected
    var cellBorderWidth: CGFloat {
        return (gm.selectedRow == row && gm.selectedCol == col && gm.cellSelected) ? 3 : 1
    }
    
    // Cell background color depending on user preference for highlighting puzzle conflicts
    var cellBackgroundColor: Color {
        if !self.preferencesManager.highlightConflicts || self.gm.puzzle.board[row][col] == 0 { return Color("cellBackground") }
        else if self.gm.puzzle.rowValueCount[row][self.gm.puzzle.board[row][col]-1] > 1 || self.gm.puzzle.colValueCount[col][self.gm.puzzle.board[row][col]-1] > 1 || self.gm.puzzle.subgridValueCount[subgrid][self.gm.puzzle.board[row][col]-1] > 1 { return Color("mainColor3") }
        else { return Color("cellBackground") }
    }
    
    // Initialize cell with row/column number, and calculating which subgrid the cell is located in
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.subgrid = (row/3) * 3 + (col/3)
    }
    
    // View used to represent a single cell on the sudoku board
    var body: some View {
        
        // Update the cell selected to the current cell when pressed
        Button(action: {
            gm.updateCellSelected(row: row, col: col)
        }) {
            ZStack {
                Text(gm.puzzle.board[row][col] != 0 ? String(gm.puzzle.board[row][col]) : " ")
                    .font(Font.custom("Petahja-Regular", size: 44))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .lineLimit(1)
                    .foregroundColor(self.cellTextColor)
                
                PencilView(row: row, col: col)
                
            }
        }
        .border(self.cellBorderColor, width: self.cellBorderWidth)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .buttonStyle(cellButtonStyle())
        .background(self.cellBackgroundColor)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(row: 0, col: 1)
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
            .environmentObject(PreferencesManager())
    }
}
