//
//  ContentView.swift
//  Note Exporter
//
//  Created by Alex on 2020/10/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bookStore: BookStore
    @State private var selectedBook: String?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            Sidebar(sidebarList: bookStore.loadSidebar(), selectedBook: $selectedBook, bookStore: bookStore)
                .frame(width: 220)
            
            Divider()
            
            if let book = selectedBook {
                DetailView(book: bookStore.books.first(where: { $0.title == book })!)
                    .frame(minWidth: 400, maxWidth: .infinity)
                    .if(colorScheme != .dark) { $0.background(Color.white) }
            } else {
                Text("Select Book...")
                    .frame(minWidth: 400, maxWidth: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bookStore: BookStore())
    }
}
