//
//  GameManager.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation
import SwiftUI

// enum used to represent sudoku input modes
enum EntryMode: Int {
    case marker
    case pencil
}

// enum used to represent puzzle difficulties/modes
enum PuzzleMode: Int, Codable {
    case easy
    case medium
    case hard
    case resume
    case menu
}

// Object used to to handle actions requested by views and store overall puzzle/puzzle view information
class GameManager: ObservableObject {
    @Published var puzzle: Puzzle
    @Published var entryMode: EntryMode
    @Published var selectedRow: Int
    @Published var selectedCol: Int
    @Published var selectedValue: Int
    @Published var cellSelected: Bool
    @Published var puzzleFinished: Bool
    
    var undoManager: UndoManager
    var puzzleMode: PuzzleMode
    
    init(puzzleMode: PuzzleMode, puzzle: Puzzle? = nil) {
        self.selectedRow = 0
        self.selectedCol = 0
        self.selectedValue = 0
        self.cellSelected = false
        self.puzzleFinished = false
        self.entryMode = .marker
        self.puzzleMode = puzzleMode
        
        if puzzle != nil {
            self.puzzle = puzzle!
        } else {
            self.puzzle = Puzzle(difficulty: puzzleMode)
        }

        self.undoManager = UndoManager()
    }
    
    // Reset board to a new puzzle of the same difficulty
    func resetPuzzle() {
        self.puzzle = Puzzle(difficulty: puzzleMode)
    }
    
    // Set the stored puzzle to a given value
    func setPuzzle(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    // Get the value of the stored puzzle
    func getPuzzle() -> Puzzle {
        return self.puzzle
    }
    
    // Set the puzzle difficulty
    func setDifficulty(puzzleMode: PuzzleMode) {
        self.puzzleMode = puzzleMode
    }
    
    // Get the puzzle difficulty
    func getDifficulty() -> PuzzleMode {
        return self.puzzleMode
    }
    
    // Set puzzle finished status
    func setPuzzleFinished(status: Bool) {
        self.puzzleFinished = status
    }
    
    // Update the selected cell row/column and selected number
    func updateCellSelected(row: Int, col: Int) {
        if self.puzzle.board[row][col] != 0 {
            self.selectedValue = self.puzzle.board[row][col]
        }
        
        if row == self.selectedRow && col == self.selectedCol {
            self.cellSelected = !self.cellSelected
        } else {
            self.selectedRow = row
            self.selectedCol = col
            self.cellSelected = true
        }
    }
    
    // Update the values of a cell based on entry mode, including a new pencil note or cell value
    func updateCellValue(value:Int, clearPencilEntries: Bool) {
        
        // If no cell is selected, or the current cell is part of the original board, do nothing
        if self.puzzle.boardLocked[selectedRow][selectedCol] { return }
        if !self.cellSelected { return }
        
        // Get the value of the current board and create a boolean to mark whether the board has changed at all
        let oldPuzzle: Puzzle = self.puzzle
        var changed = false
        
        // Update the cell value
        if self.entryMode == .marker {
            
            // Remove pencil notes from the cell
            for i in 0...8 {
                self.puzzle.boardPencil[selectedRow][selectedCol][i] = false
            }
            
            // Change the cell value, selected number, and mark whether any changes occurred
            changed = self.puzzle.updateBoardEntry(row: self.selectedRow, col: self.selectedCol, value: value, clearPencilEntries: clearPencilEntries)
            self.selectedValue = value
        }
        // Update pencil notes
        else if self.entryMode == .pencil {
            if self.puzzle.board[selectedRow][selectedCol] == 0 {
                self.puzzle.boardPencil[selectedRow][selectedCol][value-1] = !self.puzzle.boardPencil[selectedRow][selectedCol][value-1]
                changed = true
            }
        }
        
        // If the puzzle board changed, register the old and new puzzle values for undo/redo operations
        if changed {
            let newPuzzle: Puzzle = self.puzzle
            self.registerUndoRedo(oldPuzzle: oldPuzzle, newPuzzle: newPuzzle, target: self)
        }
        
        // If there are no empty cells on the puzzle board and the solution is valid, set the puzzle as finished
        if self.puzzle.numZeros == 0 && self.puzzle.boardValidated() {
            self.puzzleFinished = true
        }
    }
    
    // Toggle between marker and pencil entry modes
    func switchMode() {
        if self.entryMode == .marker {
            self.entryMode = .pencil
        } else if self.entryMode == .pencil {
            self.entryMode = .marker
        }
    }
    
    // Erase a cell's value or pencil notes
    func erase() {
        
        // If no cell is selected or the current cell is part of the original board, do nothing
        if self.puzzle.boardLocked[selectedRow][selectedCol] { return }
        if !self.cellSelected { return }
        
        // Get the value of the current board and create a boolean to mark whether the board has changed at all
        let oldPuzzle: Puzzle = self.puzzle
        var changed = false
        
        // Erase a cell's non-zero value
        if self.puzzle.board[selectedRow][selectedCol] != 0 {
            changed = self.puzzle.updateBoardEntry(row: self.selectedRow, col: self.selectedCol, value: 0, clearPencilEntries: false)
            self.selectedValue = 0
        }
        // Erase all pencil notes within a cell
        else {
            for i in 0...8 {
                if self.puzzle.boardPencil[selectedRow][selectedCol][i] {
                    self.puzzle.boardPencil[selectedRow][selectedCol][i] = false
                    changed = true
                }
            }
        }
        
        // If the puzzle board changed, register the old and new puzzle values for undo/redo operations
        if changed {
            let newPuzzle: Puzzle = self.puzzle
            self.registerUndoRedo(oldPuzzle: oldPuzzle, newPuzzle: newPuzzle, target: self)
        }
    }
    
    // Register new undo/redo operations based on an unmodified and modified puzzle board
    func registerUndoRedo(oldPuzzle: Puzzle, newPuzzle: Puzzle, target: GameManager) {
        target.undoManager.registerUndo(withTarget: target) { _ in
            target.puzzle = oldPuzzle
            target.puzzle.updateNumZeros()
            target.selectedValue = target.puzzle.board[target.selectedRow][target.selectedCol]
            target.registerUndoRedo(oldPuzzle: newPuzzle, newPuzzle: oldPuzzle, target: target)
        }
    }
    
    // Perform an undo operation
    func undo() {
        if self.undoManager.canUndo {
            self.undoManager.undo()
        }
    }
    
    // Perform a redo operation
    func redo() {
        if self.undoManager.canRedo {
            self.undoManager.redo()
        }
    }
}
