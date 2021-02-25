//
//  ContentView.swift
//  Launcher
//
//  Created by Jed Fox on 2/25/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        let shortcutName = "Mono Audio"
        VStack {
            Button("Run “\(shortcutName)”") {
                openURL(URL(string: "shortcuts://run-shortcut?name=\(shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
