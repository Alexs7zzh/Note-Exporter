//
//  DetailView.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/29.
//

import SwiftUI

struct DetailView: View {
    let book: Book
    @State var sort = 0
    @State var selection: Set<Annotation>?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            Text(book.author ?? "")
                .font(.title2)
                .padding(.bottom)
            
            Picker("sort", selection: $sort) {
                Text("By Date").tag(0)
                Text("By Location").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            
            AnnotationList(book: book.title, annotations: book.annotations, sort: sort, selection: $selection)
            
            Spacer()
        }.padding()
    }
}

