//
//  CheckersApp.swift
//  Checkers
//
//  Created by Andrew Honchar on 4/20/23.
//

import SwiftUI

@main
struct CheckersApp: App {
    var body: some Scene {
        WindowGroup {
            StartScreenView().environmentObject(CheckerView.ViewModel())
        }
    }
}
