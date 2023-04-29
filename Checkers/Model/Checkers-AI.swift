//
//  Checkers-AI.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/28/23.
//

import Foundation

struct CheckersAI {
    let depth = 15
    var game: Checkers
    
    
    func getBestMove() -> (checker: Checkers.Checker, move: (row: Int, col: Int)) {
        var moves = [(checker: Checkers.Checker, move: (row: Int, col: Int))]()
        foo(game: game, depth: 2, chosenMove: &moves)
        return moves.randomElement()!
    }
    
    func calculateScore(for color: Checkers.Color, game: Checkers) -> Int {
        var blackCount = 0
        var whiteCount = 0
        for row in game.board.indices {
            for col in game.board[row].indices {
                if let checker = game.board[row][col].cheaker {
                    if checker.color == .black{
                        blackCount += 1
                    } else {
                        whiteCount += 1
                    }
                }
            }
        }
        
        var realBlackCount = 0
        var realWhiteCount = 0
        for row in game.board.indices {
            for col in game.board[row].indices {
                if let checker = self.game.board[row][col].cheaker {
                    if checker.color == .black{
                        realBlackCount += 1
                    } else {
                        realWhiteCount += 1
                    }
                }
            }
        }
        
        
        
        if color == .black {
            return (realWhiteCount - whiteCount) - (realBlackCount - blackCount)
        } else {
            return (realBlackCount - blackCount) - (realWhiteCount - whiteCount)
        }
    }
    
    @discardableResult
    func foo(game: Checkers,depth: Int, chosenMove: inout [(checker: Checkers.Checker, move: (row: Int, col: Int))]) -> Int {
        let checkersWithPossibleMoves = getArrayCheckersWithPossibleMoves(game: game)
        
        if depth == 0 || game.checkOnGameOver() != nil || checkersWithPossibleMoves.isEmpty
        {
            return calculateScore(for: self.game.currentPlayer, game: game)
        }
        
        var bestScore: Int?
        var bestMoves = [(checker: Checkers.Checker, move: (row: Int, col: Int))]()
        for checkerWithPossibleMoves in checkersWithPossibleMoves {
            for move in checkerWithPossibleMoves.moves {
                let cell = game.getCell(by: move)
                var coppiedGame = game
                coppiedGame.makeMove(by: checkerWithPossibleMoves.cheker, to: cell!)
                let score = foo(game: coppiedGame,depth: depth - 1,chosenMove: &chosenMove)
                if game.currentPlayer == self.game.currentPlayer {
                    if bestScore == nil || score >= bestScore! {
                        if let bestScore = bestScore, score == bestScore  {
                            bestMoves.append((checkerWithPossibleMoves.cheker,move))
                        } else {
                            bestScore = score
                            bestMoves = [(checker: checkerWithPossibleMoves.cheker, move: move)]
                        }
                        
                    }
                } else if bestScore == nil || score <= bestScore! {
                    if let bestScore = bestScore, score == bestScore  {
                        bestMoves.append((checkerWithPossibleMoves.cheker,move))
                    } else {
                        bestScore = score
                        bestMoves = [(checker: checkerWithPossibleMoves.cheker, move: move)]
                    }
                    
                }
            }
        }
        chosenMove = bestMoves
        return bestScore!
    }
    
    func getArrayCheckersWithPossibleMoves(game: Checkers) -> [(cheker: Checkers.Checker,moves: [(row: Int, col: Int)])] {
        var result = [(cheker: Checkers.Checker,moves: [(row: Int, col: Int)])]() // array checkers with all possible their moves
        for row in game.board.indices {
            for col in game.board[row].indices {
                if let checker = game.board[row][col].cheaker, checker.color == game.currentPlayer {
                    let data = (checker, game.getPossibleMoves(for: checker))
                    if !data.1.isEmpty {
                        result.append(data)
                    }
                }
            }
        }
        return result
    }
    
}

