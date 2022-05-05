//
//  PuzzleGenerator.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation

// Object containing a series of methods used to generate puzzles of easy difficulty
class PuzzleGenerator {
    
    // Calculate the range values of a given coordinate's position on the sudoku board
    private func calculateRegionRange(xLow: inout Int, xHigh: inout Int, yLow: inout Int, yHigh: inout Int, x:Int, y:Int) {
        let blockRow: Int = x / 3
        let blockCol: Int = y / 3
        
        xLow = blockRow * 3
        yLow = blockCol * 3
        xHigh = xLow + 2
        yHigh = yLow + 2
    }

    // Test if a value fits the constraints of the sudoku board in a certain location
    private func testValue(board: inout [[Int]], number:Int, x:Int, y:Int) -> Bool {
        if board[x][y] != 0 { return false }
        for j in 0...8 {
            if board[x][j] == number || board[j][y] == number { return false }
        }
        
        var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
        self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: x, y: y)
        
        for xCoord in xLow...xHigh {
            for yCoord in yLow...yHigh {
                if board[xCoord][yCoord] == number { return false }
            }
        }
        return true
    }

    // Check a board to ensure the solution is valid
    func validateBoard(board: inout [[Int]]) -> Bool {
        for x in 0...8 {
            for y in 0...8 {
                if board[x][y] == 0 || board[x].contains(0) { return false }
                
                var rowCopy = board[x]
                var columnCount:[Int:Int] = [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0]
                for i in 1...9 {
                    rowCopy = rowCopy.filter { $0 != i }
                    if rowCopy.count != 9-i { return false }
                    if board[i-1][y] == 0 { return false }
                    columnCount[board[i-1][y]]! += 1
                    if columnCount[board[i-1][y]] == 2 { return false }
                }
                
                var regionCount:[Int:Int] = [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0]
                
                var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
                self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: x, y: y)
                
                for xCoord in xLow...xHigh {
                    for yCoord in yLow...yHigh {
                        if board[xCoord][yCoord] == 0 { return false }
                        regionCount[board[xCoord][yCoord]]! += 1
                        if regionCount[board[xCoord][yCoord]] == 2 { return false }
                    }
                }
            }
        }
        
        return true
    }

    // Generate the possible numbers that could be inserted into each space
    private func generatePossibleChoices(board: inout [[Int]]) -> [[[Int]]] {
        
        let choices = [1,2,3,4,5,6,7,8,9]
        let choicesColumns = [[Int]](repeating: choices, count: 9)
        var possibleChoices = [[[Int]]](repeating: choicesColumns, count: 9)
        
        for x in 0...8 {
            for y in 0...8 {
                if board[x][y] != 0 {
                    possibleChoices[x][y] = []
                    continue
                }
                
                for i in 0...8 {
                    if i != y { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[x][i] } }
                    if i != x { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[i][y] } }
                }
                
                var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
                self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: x, y: y)
                
                for xCoord in xLow...xHigh {
                    for yCoord in yLow...yHigh {
                        if !(xCoord == x && yCoord == y) { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[xCoord][yCoord] } }
                    }
                }
            }
        }
        
        return possibleChoices
    }


    // Remove a number from the list of possible numbers in the row, column, and region of a space after a number is inserted there
    private func removePossibleChoices(possibleChoices: inout [[[Int]]], x:Int, y:Int, number: Int) {
        for i in 0...8 {
            if i != y { possibleChoices[x][i] = possibleChoices[x][i].filter { $0 != number } }
            if i != x { possibleChoices[i][y] = possibleChoices[i][y].filter { $0 != number } }
        }
        
        var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
        self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: x, y: y)
        
        for i in xLow...xHigh {
            for j in yLow...yHigh {
                if !(i == x && j == y) { possibleChoices[i][j] = possibleChoices[i][j].filter { $0 != number } }
            }
        }
    }

    // Updates the array of possible choices for each space after backtracking occurs during sudoku board creation
    private func updatePossibleChoices(board: inout [[Int]], possibleChoices: inout [[[Int]]]) {
        for x in 0...8 {
            for y in 0...8 {
                if board[x][y] != 0 { continue }
                possibleChoices[x][y] = [1,2,3,4,5,6,7,8,9]
                
                for i in 0...8 {
                    if i != y { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[x][i] } }
                    if i != x { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[i][y] } }
                }
                
                var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
                self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: x, y: y)
                
                for xCoord in xLow...xHigh {
                    for yCoord in yLow...yHigh {
                        if !(xCoord == x && yCoord == y) { possibleChoices[x][y] = possibleChoices[x][y].filter { $0 != board[xCoord][yCoord] } }
                    }
                }
            }
        }
    }

    // Generate array of shuffled sudoku coordinates to facilitate number removal process
    private func generateShuffledCoordinates() -> [[Int]] {
        var collection = [[Int]]()
        for x in 0...8 {
            for y in 0...8 {
                collection.append([x,y])
            }
        }
        
        collection.shuffle()
        return collection
    }

    // Calculate the number of solutions a partial sudoku board has
    private func numberOfSolutions(board: inout [[Int]]) -> Int {
        var solutions = 0
        var emptyPositions = [[Int]]()
        
        for x in 0...8 {
            for y in 0...8 {
                if board[x][y] == 0 { emptyPositions.append([x,y]) }
            }
        }
        
        self.numberOfSolutionsHelper(board: &board, solutions: &solutions, emptyPositions: &emptyPositions, position: 0)
        
        return solutions
    }

    // Recursive helper function to calculate the number of solutions a partial sudoku board has
    private func numberOfSolutionsHelper(board: inout [[Int]], solutions: inout Int, emptyPositions: inout [[Int]], position:Int) {
        if position == emptyPositions.count && validateBoard(board: &board) {
            solutions += 1
            return
        }
        else if position == emptyPositions.count { return }
        else if solutions == 2 { return }
        
        for number in 1...9 {
            if testValue(board: &board, number: number, x: emptyPositions[position][0], y: emptyPositions[position][1]) {
                board[emptyPositions[position][0]][emptyPositions[position][1]] = number
                self.numberOfSolutionsHelper(board: &board, solutions: &solutions, emptyPositions: &emptyPositions, position: position + 1)
                board[emptyPositions[position][0]][emptyPositions[position][1]] = 0
            }
        }
    }

    // Look for positions on the board where only one number is allowed to be inserted
    private func nakedSingleSolver(board: inout [[Int]], possibleChoices: inout [[[Int]]]) -> Int {
        var spacesChanged:Int = 0
        
        for x in 0...8 {
            for y in 0...8 {
                if possibleChoices[x][y].count == 1 {
                    board[x][y] = possibleChoices[x][y][0]
                    possibleChoices[x][y] = []
                    self.removePossibleChoices(possibleChoices: &possibleChoices, x: x, y: y, number: board[x][y])
                    spacesChanged += 1
                }
            }
        }
        
        return spacesChanged
    }

    // Look for numbers on the board that can only go in one spot in a row, column, or region
    private func hiddenSingleSolver(board: inout [[Int]], possibleChoices: inout [[[Int]]]) -> Int {
        var spacesChanged:Int = 0
        
        for x in 0...8 {
            for number in 1...9 {
                var firstIndex = -1
                var occurences = 0
                for y in 0...8 {
                    if possibleChoices[x][y].contains(number) {
                        if occurences > 0 {
                            firstIndex = -1
                            break
                        }
                        else {
                            occurences += 1
                            firstIndex = y
                        }
                    }
                }
                
                if firstIndex != -1 {
                    board[x][firstIndex] = number
                    possibleChoices[x][firstIndex] = []
                    self.removePossibleChoices(possibleChoices: &possibleChoices, x: x, y: firstIndex, number: number)
                    spacesChanged += 1
                }
            }
        }
        
        for x in 0...8 {
            for number in 1...9 {
                var firstIndex = -1
                var occurences = 0
                for y in 0...8 {
                    if possibleChoices[y][x].contains(number) {
                        if occurences > 0 {
                            firstIndex = -1
                            break
                        }
                        else {
                            occurences += 1
                            firstIndex = y
                        }
                    }
                }
                
                if firstIndex != -1 {
                    board[firstIndex][x] = number
                    possibleChoices[firstIndex][x] = []
                    self.removePossibleChoices(possibleChoices: &possibleChoices, x: firstIndex, y: x, number: number)
                    spacesChanged += 1
                }
            }
        }
        
        let startingRegionCoordinates = [ [0,0], [0,3], [0,6], [3,0], [3,3], [3,6], [6,0], [6,3], [6,6] ]
        for coord in startingRegionCoordinates {
            let xCoord = coord[0], yCoord = coord[1]
            var xLow:Int = -1, xHigh:Int = -1, yLow:Int = -1, yHigh:Int = -1
            self.calculateRegionRange(xLow: &xLow, xHigh: &xHigh, yLow: &yLow, yHigh: &yHigh, x: xCoord, y: yCoord)
            for number in 1...9 {
                var firstIndex = (-1,-1)
                var occurences = 0
                var broken = false
                for x in xLow...xHigh {
                    for y in yLow...yHigh {
                        if possibleChoices[x][y].contains(number) {
                            if occurences > 0 {
                                firstIndex = (-1,-1)
                                broken = true
                                break
                            }
                            else {
                                occurences += 1
                                firstIndex = (x,y)
                            }
                        }
                    }
                    if broken { break }
                }
                
                if firstIndex.0 != -1 {
                    board[firstIndex.0][firstIndex.1] = number
                    possibleChoices[firstIndex.0][firstIndex.1] = []
                    self.removePossibleChoices(possibleChoices: &possibleChoices, x: firstIndex.0, y: firstIndex.1, number: number)
                    spacesChanged += 1
                }
            }
        }
        
        return spacesChanged
    }

    // Use the implemented sudoku solving methods to solve the board, or abandon if the puzzle cannot be solved
    private func solveBoard(board:[[Int]], difficulty:Int) -> Bool {
        if difficulty == -1 { return false }
        
        var board = board
        var possibleChoices = self.generatePossibleChoices(board: &board)
        
        while true {
            var spacesChanged = 0
            spacesChanged += self.nakedSingleSolver(board: &board, possibleChoices: &possibleChoices)
            spacesChanged += self.hiddenSingleSolver(board: &board, possibleChoices: &possibleChoices)
            
            if spacesChanged == 0 { break }
        }
        
        if self.validateBoard(board: &board) { return true }
        else { return false }
    }

    // Function that calls for sudoku board generation and discards invalid boards until a valid board is generated from the helper
    private func generateBoard() -> [[Int]] {
        while true {
            var board = self.generateBoardHelper()
            if self.validateBoard(board: &board) { return board }
        }
    }

    // Helper function that randomly generates sudoku boards linearly, backtracks through rows to remedy failures due to constraints, or abandons boards when unable to remedy failures
    private func generateBoardHelper() -> [[Int]] {
        var board = [[Int]](repeating: [0,0,0,0,0,0,0,0,0], count: 9)
        let choices = [1,2,3,4,5,6,7,8,9]
        let choicesColumns = [[Int]](repeating: choices, count: 9)
        var possibleChoices = [[[Int]]](repeating: choicesColumns, count: 9)
        
        for x in 0...8 {
            for y in 0...8 {
                var number = Int(arc4random_uniform(UInt32(possibleChoices[x][y].count)))
                if possibleChoices[x][y].count == 0 {
                    var rowChoices = [1,2,3,4,5,6,7,8,9]
                    for i in 0...y {
                        rowChoices = rowChoices.filter { $0 != board[x][i] }
                    }
                    
                    var successfulSwitch = false
                    for numberChoice in rowChoices {
                        for i in stride(from: y-1, through: 0, by: -1) {
                            let numberHolder = board[x][i]
                            board[x][i] = 0
                            if self.testValue(board: &board, number: numberChoice, x: x, y: i) && testValue(board: &board, number: numberHolder, x: x, y: y) {
                                board[x][i] = numberChoice
                                board[x][y] = numberHolder
                                successfulSwitch = true
                                self.updatePossibleChoices(board: &board, possibleChoices: &possibleChoices)
                                break
                            }
                            else {
                                board[x][i] = numberHolder
                            }
                        }
                        if successfulSwitch { break }
                    }
                    
                    if !successfulSwitch {
                        return board
                    }
                }
                else {
                    number = possibleChoices[x][y][number]
                    board[x][y] = number
                    self.removePossibleChoices(possibleChoices: &possibleChoices, x: x, y: y, number: number)
                    possibleChoices[x][y] = []
                }
            }
        }
        
        return board
    }

    // Takes a completed sudoku board and removes numbers from the board to create a puzzle of the specified difficulty
    func generatePuzzle(difficulty:Int) -> [[Int]] {
        let boardMaster = self.generateBoard()
        while true {
            var board = boardMaster
            var occupiedCoordinates = self.generateShuffledCoordinates()
            var emptyCoordinates = [[Int]]()
            
            for _ in 0...39 {
                var toRemove = occupiedCoordinates.removeFirst()
                toRemove.append(board[toRemove[0]][toRemove[1]])
                board[toRemove[0]][toRemove[1]] = 0
                emptyCoordinates.append(toRemove)
            }
            
            if self.numberOfSolutions(board: &board) == 1 && self.solveBoard(board: board, difficulty: difficulty) { return board }
        }
    }
}
