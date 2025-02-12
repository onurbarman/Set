//
//  SetApp.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
