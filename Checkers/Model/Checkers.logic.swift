//
//  Checkers.logic.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/24/23.
//

import Foundation
extension Checkers {
    mutating func onCheckerTap(_ checker: Checker) {
         if let unwrappedSelectedChecker = selectedChecker, unwrappedSelectedChecker == checker {
             selectedChecker = nil
         } else {
             guard currentPlayer == checker.color else { return }
             selectedChecker = checker
         }
        
        recalculateHighlitedCells()
     }
    
    mutating func onTapCell(_ cell:Cell) {
        if selectedChecker == nil || !cell.highlited {
            return
        }
        makeMove(by: selectedChecker!, to: cell)
        
        recalculateHighlitedCells()
        
        let isGameOver = checkOnGameOver() != nil
        if !isGameOver && IsGameWithAI && currentPlayer == .black {
            makeAIMove()
        }
    }
    
    mutating func recalculateHighlitedCells() {
        for row in board.indices {
            for col in board[row].indices {
                board[row][col].highlited = false
            }
        }
        if selectedChecker == nil {
            return
        }
        let moves = getPossibleMoves(for: selectedChecker!)
        for move in moves  {
            board[move.row][move.col].highlited = true
        }
    }
    mutating func makeMove(by checker: Checkers.Checker, to cell: Checkers.Cell) {
        let cheackerPos = getPos(of: checker)
        let cellPos = getPos(of: cell)
        let moveOverEnemy = canMoveOverEnemy(by: checker, to: cell)
        board[cellPos.row][cellPos.col].cheaker = checker
        board[cheackerPos.row][cheackerPos.col].cheaker = nil
        if cellPos.row == 0 && checker.color == .black ||
           cellPos.row == boardSize.height - 1 && checker.color == .white
        {
            board[cellPos.row][cellPos.col].cheaker!.isKing = true
        }
        selectedChecker = nil
        
        if moveOverEnemy {
            let enemyPos: (row: Int, col: Int) = (cheackerPos.row < cellPos.row ? cellPos.row - 1 : cellPos.row + 1,
                                                  cheackerPos.col < cellPos.col ? cellPos.col - 1 : cellPos.col + 1)
            board[enemyPos.row][enemyPos.col].cheaker = nil
        }
        if !(moveOverEnemy && isThereMoveOverEnemy(for: checker)) {
            currentPlayer = currentPlayer == .black ? .white : .black
            nextMoveCanMakeOnlyOneChecker = false
        } else {
            nextMoveCanMakeOnlyOneChecker = true
            oneChecker = checker
        }
    }
    
    mutating func makeAIMove()
    {
        let prevPlayer = currentPlayer
        repeat {
            let AI = CheckersAI(game: self)
            let move = AI.getBestMove()
            let cell = getCell(by: move.move)!
            let checkerPos = getPos(of: move.checker)
            board[checkerPos.row][checkerPos.col].highlited = true
            print("AI moved to: \(move.move)")
            makeMove(by: move.checker, to: cell)
            
        }
        while prevPlayer == currentPlayer
                
    }
    
    func checkOnGameOver() -> Color?
    {
        let isBlackOnBoard = isThereColorOnBoard(color: .black)
        let isWhiteOnBoard = isThereColorOnBoard(color: .white)
        if isBlackOnBoard && isWhiteOnBoard {
            return nil
        } else if !isBlackOnBoard {
            return .black
        } else {
            return .white
        }
    }
}
