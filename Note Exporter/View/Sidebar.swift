//
//  Sidebar.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/29.
//

import SwiftUI

struct SidebarItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct Sidebar: View {
    var sidebarList: [SidebarItem]
    @Binding var selectedBook: String?
    var bookStore: BookStore
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack {
                Text("Books")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    bookStore.load()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.system(size: 18))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(sidebarList) { item in
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .lineLimit(2)
                        .if(item.name == selectedBook) {
                            $0.foregroundColor(Color.blue)
                        }
                        .onTapGesture {
                            self.selectedBook = item.name
                        }
                }
            }.padding(.horizontal)
            
            Spacer()
        }
    }
}

