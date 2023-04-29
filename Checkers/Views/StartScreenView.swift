//
//  StartScreenView.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/25/23.
//

import SwiftUI

struct StartScreenView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: CheckerView().navigationBarBackButtonHidden(true)) {
                    LargeButton(title: "Play with a friend", backgroundColor: .green){}
                        .allowsHitTesting(false)
                }
                NavigationLink(destination: CheckerView()) {
                    LargeButton(title: "Play with a computer", backgroundColor: .brown){}
                        .allowsHitTesting(false)
                }
                NavigationLink(destination: CheckerView()) {
                    LargeButton(title: "Options", backgroundColor: .yellow){}
                        .allowsHitTesting(false)
                }
            }
        }.toolbarBackground(.black, for: .navigationBar)
    }
}

struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
    }
}
