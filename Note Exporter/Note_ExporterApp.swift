//
//  Note_ExporterApp.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/28.
//

import SwiftUI

@main
struct Note_ExporterApp: App {
    @StateObject var bookStore = BookStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(bookStore: bookStore)
                .frame(minHeight: 600, maxHeight: .infinity)
        }
    }
}
