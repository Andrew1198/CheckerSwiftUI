//
//  Checkers.utility.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/24/23.
//

import Foundation
extension Checkers {
    func getPos(of checker: Checker) -> (row:Int,col:Int) {
        for row in 0..<boardSize.height {
            for col in 0..<boardSize.width {
                if let checker2 = board[row][col].cheaker, checker2 == checker {
                    return (row,col)
                }
            }
        }
            
        print("Error \(#function)")
        return (-1,-1)
    }
    
    func getPos(of cell: Cell) -> (row:Int,col:Int) {
        for row in 0..<boardSize.height {
            for col in 0..<boardSize.width {
                if board[row][col] == cell {
                    return (row,col)
                }
            }
        }
        print("Error \(#function)")
        return (-1,-1)
    }
    
    func getCell(by pos: (row:Int, col:Int)) -> Cell? {
            guard pos.row >= 0 && pos.row < boardSize.height
                    && pos.col >= 0 && pos.col < boardSize.width else { return nil }
        return board[pos.row][pos.col]
    }
    
    func getPossibleMoves(for checker: Checker) -> [(row: Int, col: Int)] {
        let allMoves: Array<(y:Int, x:Int)> = getPlainForwardMoves(isKing: checker.isKing) + getPlainOverEnemyMoves(isKing: checker.isKing)
        let checkerPos = getPos(of: checker)
        var result = [(row: Int, col: Int)]()
        
        for move in allMoves {
            let cellPos = (row: checkerPos.row + move.y, col: checkerPos.col + move.x)
            if let cell = getCell(by: cellPos), canMove(by: checker, to: cell) {
                if !result.contains(where: { value in
                    value.col == cellPos.col && value.row == cellPos.row
                }) {
                    result.append(cellPos)
                }
            }
        }
        return result
    }
    
    
    
    func canMove(by checker: Checkers.Checker, to cell: Checkers.Cell) -> Bool {
        if canMoveOverEnemy(by: checker, to: cell) {
            return true
        }
        
        if isThereMoveOverEnemy(ourColor: checker.color) {
            return false
        }
        
        return canMoveForward(by: checker, to: cell)
    }
    
     func canMoveOverEnemy(by checker: Checkers.Checker, to cell: Checkers.Cell) -> Bool
    {
        guard cell.cheaker == nil else { return false }
        
        let cellPos = getPos(of: cell)
        let checkerPos = getPos(of: checker)
        
        if !checker.isKing {
            guard abs(cellPos.row - checkerPos.row) == 2 &&
                    abs(cellPos.row - checkerPos.row) == abs(cellPos.row - checkerPos.row)  else {return false}
            
            let enemyPos = (row: checkerPos.row < cellPos.row ? checkerPos.row + 1 : checkerPos.row - 1,
                            col: checkerPos.col < cellPos.col ? checkerPos.col + 1 : checkerPos.col - 1)
            if let enemyChecker = board[enemyPos.row][enemyPos.col].cheaker, enemyChecker.color != checker.color {
                return true
            }
        } else {
            guard abs(cellPos.row - checkerPos.row) == abs(cellPos.col - checkerPos.col) else { return false }
            var dirToCell: (y: Int, x: Int) = ((cellPos.row - checkerPos.row).clamped(to: -1...1),
                                                (cellPos.col - checkerPos.col).clamped(to: -1...1))
            var wasEnemyOnWayCount = 0
            var wasAllyOnWay = false
            var tmpCellPos = (row: checkerPos.row + dirToCell.y, col: checkerPos.col + dirToCell.x)
            
            while tmpCellPos != cellPos {
                if let tmpCell = getCell(by: tmpCellPos), let tmpChecker = tmpCell.cheaker {
                    if tmpChecker.color == checker.color {
                        wasAllyOnWay = true
                    } else {
                        wasEnemyOnWayCount += 1
                    }
                }
                tmpCellPos = (tmpCellPos.row + dirToCell.y, tmpCellPos.col + dirToCell.x)
            }
            if !wasAllyOnWay && wasEnemyOnWayCount == 1 {
                dirToCell = (dirToCell.y * -1, dirToCell.x * -1)
                if board[cellPos.row + dirToCell.y][cellPos.col + dirToCell.x].cheaker != nil {
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate func canMoveForward(by checker: Checkers.Checker, to cell: Checkers.Cell) -> Bool
    {
        guard cell.cheaker == nil else { return false }
        
        let cellPos = getPos(of: cell)
        let checkerPos = getPos(of: checker)
        
        if !checker.isKing
        {
            let dirToEnemy = checker.color == .black ? -1 : 1
            if (cellPos.row - checkerPos.row) * dirToEnemy == 1 {
                return true
            }
        } else {
            guard abs(cellPos.row - checkerPos.row) == abs(cellPos.col - checkerPos.col) else { return false }
            var dirToCell: (y: Int, x: Int) = (cellPos.row - checkerPos.row,
                                               cellPos.col - checkerPos.col)
            dirToCell = (dirToCell.y.clamped(to: -1...1), dirToCell.x.clamped(to: -1...1))
            var wasEnemyOnWayCount = 0
            var wasAllyOnWay = false
            var tmpCellPos = (row: checkerPos.row + dirToCell.y, col: checkerPos.col + dirToCell.x)
            
            while tmpCellPos != cellPos {
                if let tmpCell = getCell(by: tmpCellPos), let tmpChecker = tmpCell.cheaker {
                    if tmpChecker.color == checker.color {
                        wasAllyOnWay = true
                    } else {
                        wasEnemyOnWayCount += 1
                    }
                }
                tmpCellPos = (tmpCellPos.row + dirToCell.y, tmpCellPos.col + dirToCell.x)
            }
            if !wasAllyOnWay && wasEnemyOnWayCount == 0 {
                return true
            }
        }
        
        return false
    }
    
    
    func isThereMoveOverEnemy(ourColor color: Color) -> Bool {
        for row in board.indices {
            for col in board.indices {
                if let checker = board[row][col].cheaker, checker.color == color {
                    if isThereMoveOverEnemy(for: checker) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isThereMoveOverEnemy(for checker: Checkers.Checker) -> Bool {
        if nextMoveCanMakeOnlyOneChecker && oneChecker! != checker {
            return false
        }
        let checkerPos = getPos(of: checker)
        let movesOverEnemy = getPlainOverEnemyMoves(isKing: checker.isKing)
        for moveOverEnemy in movesOverEnemy {
            if let cell = getCell(by: (checkerPos.row + moveOverEnemy.y, checkerPos.col + moveOverEnemy.x)), canMoveOverEnemy(by: checker, to: cell) {
                return true
            }
        }
        return false
    }
    
    
    // returns all possible moves independently what's going on the board
    fileprivate func getPlainForwardMoves(isKing: Bool) -> [(y: Int, x: Int)] {
        if !isKing {
            return [(1,1),(1,-1),(-1,1),(-1,-1)]
        } else {
          return getPlainMovesForKing()
        }
    }
    
    fileprivate func getPlainOverEnemyMoves(isKing: Bool) -> [(y: Int, x: Int)] {
        if !isKing {
            return [(2,2),(2,-2),(-2,2),(-2,-2)]
        } else {
          return getPlainMovesForKing()
        }
    }
    
    fileprivate func getPlainMovesForKing() -> [(y: Int, x: Int)] {
        var res = [(y: Int, x: Int)]()
        for i in 1 ..< boardSize.height {
            res.append((i,i))
            res.append((i,-i))
            res.append((-i,i))
            res.append((-i,-i))
        }
      return res
    }
    
    func isThereColorOnBoard(color: Color) -> Bool {
        for row in board.indices {
            for col in board[row].indices {
                if let checker = board[row][col].cheaker, checker.color == color {
                    return true
                }
            }
        }
        return false
    }
}




extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
