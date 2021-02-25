//
//  ContentView.swift
//  Launcher
//
//  Created by Jed Fox on 2/25/21.
//

import SwiftUI

struct XCallbackURL {
    let action: String
    let source: String?
    let success: URL?
    let error: URL?
    let cancel: URL?

    init?(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "x-callback-url" else {
            return nil
        }
        action = components.path
        source = components.queryItems?.first { $0.name == "x-source" }?.value
        success = components.queryItems?.first { $0.name == "x-success" }?.value.flatMap(URL.init(string:))
        error = components.queryItems?.first { $0.name == "x-error" }?.value.flatMap(URL.init(string:))
        cancel = components.queryItems?.first { $0.name == "x-cancel" }?.value.flatMap(URL.init(string:))
        print(url, action, source, success, error, cancel)
    }

    func replyWith(_ result: String, openURL: OpenURLAction) {
        if let success = success,
              var components = URLComponents(url: success, resolvingAgainstBaseURL: false) {
            if components.queryItems != nil {
                components.queryItems!.append(.init(name: "result", value: result))
            } else {
                components.query = "result=" + result
            }
            if let url = components.url {
                print(url)
                openURL(url)
            }
        }
    }
}

struct ContentView: View {
    @State var callback: XCallbackURL?
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack {
            Text("Hello from \(callback?.source ?? "<unknown>")!")
            Button("Run “Apple Frames”") {
                callback?.replyWith("Guided Access", openURL: openURL)
            }.disabled(callback == nil)
        }
        .padding()
        .onOpenURL { url in
            callback = XCallbackURL(url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
