//
//  Puzzle.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation
import SwiftUI

// Struct used to keep track of all puzzle information, including board values, pencil notes, locked spaces, board conflicts
struct Puzzle: Codable {
    var board: [[Int]]
    var boardPencil: [[[Bool]]]
    var boardLocked: [[Bool]]
    var rowValueCount: [[Int]]
    var colValueCount: [[Int]]
    var subgridValueCount: [[Int]]
    var numZeros: Int

    init(difficulty: PuzzleMode) {
        
        // If an easy puzzle is requested, generate one
        if difficulty == .easy {
            let puzzleGenerator = PuzzleGenerator()
            self.board = puzzleGenerator.generatePuzzle(difficulty: 0)
        }
        
        // If a non-easy puzzle is requested, get one from storage
        else {
            let puzzleFile = difficulty == .medium ? "mediumPuzzleSeeds" : "hardPuzzleSeeds"
            let dataHandler = DataHandler()
            self.board = dataHandler.readPuzzleFromFile(puzzleFile: puzzleFile)
        }
        
        // Set all non-board variables to default values
        self.boardPencil = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: false, count: 9), count: 9), count: 9)
        self.boardLocked = [[Bool]](repeating: [Bool](repeating: false, count: 9), count: 9)
        self.rowValueCount = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        self.colValueCount = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        self.subgridValueCount = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        self.numZeros = 81
        
        // Update non-board variables based on board values
        for row in 0...8 {
            for col in 0...8 {
                let subgrid = self.getSubgrid(row: row, col: col)
                let value = self.board[row][col]
                
                if value != 0 {
                    self.boardLocked[row][col] = true
                    self.rowValueCount[row][value-1] += 1
                    self.colValueCount[col][value-1] += 1
                    self.subgridValueCount[subgrid][value-1] += 1
                    self.numZeros -= 1
                }
            }
        }
    }
    
    // Test whether a sudoku solution is valid using the puzzle generator object
    func boardValidated() -> Bool {
        let puzzleGenerator = PuzzleGenerator()
        var board = self.board
        return puzzleGenerator.validateBoard(board: &board)
    }
    
    // Calculate which subgrid a cell belongs to based on its row/column
    func getSubgrid(row: Int, col: Int) -> Int {
        let result: Int = (row/3) * 3 + (col/3)
        return result
    }
    
    // Clear pencil notes in a cell's row, column, and subgrid
    mutating func clearPencilEntries(row: Int, col: Int, value: Int) {
        // Calulate the range of rows/columns of the given cell's subgrid
        let blockRow: Int = row / 3
        let blockCol: Int = col / 3
        let rowMin: Int = blockRow * 3
        let colMin: Int = blockCol * 3
        let rowMax: Int = rowMin + 2
        let colMax: Int = colMin + 2
        
        // Clear pencil notes for the given value in the cell's subgrid
        for r in rowMin...rowMax {
            for c in colMin...colMax {
                self.boardPencil[r][c][value-1] = false
            }
        }
        
        // Clear pencil notes for the given value in the cell's row and column
        for i in 0...8 {
            self.boardPencil[row][i][value-1] = false
            self.boardPencil[i][col][value-1] = false
        }
    }
    
    // Update a cell's value and update puzzle conflict information
    mutating func updateBoardEntry(row: Int, col: Int, value: Int, clearPencilEntries: Bool) -> Bool {
        
        // Get the cell's subgrid and previous value
        let subgrid = self.getSubgrid(row: row, col: col)
        let oldValue = self.board[row][col]
        
        // Update row/column/subgrid counts based on previous cell value
        if oldValue != 0 {
            self.rowValueCount[row][oldValue-1] -= 1
            self.colValueCount[col][oldValue-1] -= 1
            self.subgridValueCount[subgrid][oldValue-1] -= 1
        }
        
        // Update row/column/subgrid counts based on new cell value
        if value != 0 {
            self.rowValueCount[row][value-1] += 1
            self.colValueCount[col][value-1] += 1
            self.subgridValueCount[subgrid][value-1] += 1
        }
        
        // Update number of zeros count based on previous and new cell values
        if oldValue == 0 && value != 0 { self.numZeros -= 1 }
        else if oldValue != 0 && value == 0 { self.numZeros += 1 }
        
        // Update the cell value
        self.board[row][col] = value
        let changed = oldValue != value
        
        // Clear pencil entries in the cell's row/column/subgrid if a change occurred and user preferences dictate to do so
        if clearPencilEntries && changed && value != 0 {
            self.clearPencilEntries(row: row, col: col, value: value)
        }
        
        // Return whether the cell value changed or not
        return changed
    }
    
    // Recalculate the number of empty spaces on the board
    mutating func updateNumZeros() {
        self.numZeros = 0
        for row in 0...8 {
            for col in 0...8 {
                if self.board[row][col] == 0 { self.numZeros += 1 }
            }
        }
    }
}
