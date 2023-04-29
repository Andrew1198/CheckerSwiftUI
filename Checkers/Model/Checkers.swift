//
//  Checkers.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/20/23.
//

import Foundation

struct Checkers {
    let boardSize: (width: Int, height: Int) = (8,8)
    var board: [[Cell]]
    var selectedChecker: Checker?
    var currentPlayer: Color = .white
    var IsGameWithAI = true
    var nextMoveCanMakeOnlyOneChecker: Bool = false
    var oneChecker: Checker?
    enum Color: Hashable {
        case black
        case white
        
    }
    struct Checker: Identifiable, Hashable {
        var id = UUID()
        var isKing = false
        let color: Color
    }
    
    struct Cell: Identifiable, Hashable {
        var id = UUID()
        var cheaker: Checker?
        let color: Color
        var highlited = false
    }
    
    init() {
        board = [[Cell]]()
        
        //Putting Cells
        for row in 0..<boardSize.height {
            board.append([Cell]())
            for col in 0..<boardSize.width {
                var color: Color
                if row % 2 == 1 {
                    color = col % 2 == 0 ? .black : .white
                } else {
                    color = col % 2 == 0 ? .white: .black
                }
                board[row].append(Cell(color: color))
            }
        }
        
        // Putting chekers
        for i in 0..<boardSize.width {
            if i % 2 == 0 {
                board[boardSize.height - 1][i].cheaker = Checker(color: .black)
                board[boardSize.height - 3][i].cheaker = Checker(color: .black)
                board[1][i].cheaker = Checker(color: .white)
            } else {
                board[0][i].cheaker = Checker(color: .white)
                board[2][i].cheaker = Checker(color: .white)
                board[boardSize.height - 2][i].cheaker = Checker(color: .black)
            }
        }
        
        
        
//                board[3][0].cheaker = Checker(isKing: false, color: .black)
//                board[0][7].cheaker = Checker(isKing: true, color: .black)
        
        
        // Putting chekers
//        for i in 0..<boardSize.width {
//            if i % 2 == 0 {
//                //board[boardSize.height - 1][i].cheaker = Checker(color: .black)
//                //board[boardSize.height - 3][i].cheaker = Checker(color: .black)
//                board[1][i].cheaker = Checker(color: .white)
//            } else {
//                board[0][i].cheaker = Checker(color: .white)
//                board[2][i].cheaker = Checker(color: .white)
//                //board[boardSize.height - 2][i].cheaker = Checker(color: .black)
//            }
//        }
//        board[7][0].cheaker = Checker(isKing: true,color: .black)
    }
    
   
    
    
    
}


