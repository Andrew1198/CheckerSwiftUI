//
//  SwiftUIView.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/27/23.
//

import SwiftUI

struct GameOverView: View {
    var winner: Checkers.Color
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("GameOver")
                    .font(.largeTitle)
                
                let winnerName = winner == .black ? "Black" : "White"
                Text("\(winnerName) wins")
                
                LargeButton(title: "Play again", backgroundColor: .green){}
                LargeButton(title: "Main menu", backgroundColor: .green){}
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(winner: .black)
    }
}
