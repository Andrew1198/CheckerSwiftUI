//
//  CheckersViewModel.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/20/23.
//

import SwiftUI
extension CheckerView {
    class ViewModel : ObservableObject {
        var prevState = Checkers()
        @Published private(set) var model = Checkers()
        
        @Published var winnerColor: Checkers.Color?
        
        var board: [[Checkers.Cell]] {model.board}
        
        var boardSize: (width: Int, height: Int) {model.boardSize}
        
        func onCheckerTap(_ cheker: Checkers.Checker) {
            print("OnCheckerTap")
            model.onCheckerTap(cheker)
        }
        
        func onTapCell(_ cell: Checkers.Cell) {
            prevState = model
            print("OnTapCell")
            model.onTapCell(cell)
            if let color = model.checkOnGameOver() {
                winnerColor = color
            }
        }
        
        func undo(){
            model = prevState
        }
    }
}

