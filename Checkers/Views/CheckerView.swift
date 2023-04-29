//
//  CalculatorView.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/20/23.
//

import SwiftUI

struct CheckerView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if let winnerColor = viewModel.winnerColor {
            GameOverView(winner: winnerColor)
        } else {
            VStack {
                cheats
                board
            }.padding()
        }
    }
    
    
    
    var board : some View {
        VStack(spacing: 0){
            ForEach(viewModel.board, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row){ cell in
                        ZStack {
                            let color = cell.color == .black ? Color.black : Color.brown
                            let cellOpacity = cell.highlited ? 0.2 : 1
                            Rectangle()
                                .foregroundColor(color)
                                .aspectRatio(1, contentMode: .fit)
                                .opacity(cellOpacity)
                                .onTapGesture {
                                        viewModel.onTapCell(cell)
                                }
                            if cell.cheaker != nil {
                                let checkerColor: Color = cell.cheaker!.color == .black ? .red : .white
                                ZStack {
                                    let imageName = cell.cheaker!.isKing ? "circle.fill" : "circle.circle"
                                    Image(systemName: imageName).foregroundColor(checkerColor)
                                    Rectangle()
                                        .aspectRatio(1, contentMode: .fit)
                                        .opacity(0)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture { viewModel.onCheckerTap(cell.cheaker!) }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var cheats: some View {
        VStack {
            let colorToString = viewModel.model.currentPlayer == .black ? "black" : "white"
            let currentplayer = "Current player: " + colorToString
            Text(currentplayer)
            
            let isThereMoveOverEnemy = viewModel.model.isThereMoveOverEnemy(ourColor: viewModel.model.currentPlayer)
            let isThereMoveOverEnemyText = "is there move over enemy " + String(isThereMoveOverEnemy)
            Text(isThereMoveOverEnemyText)
            Button(action: viewModel.undo) {
                Text("Undo")
            }
        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CheckerView().environmentObject(CheckerView.ViewModel())
    }
}
