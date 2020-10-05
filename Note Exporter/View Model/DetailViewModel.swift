//
//  DetailViewModel.swift
//  Note Exporter
//
//  Created by Alex on 2020/10/03.
//

import Foundation

struct AnnotationListItem: Identifiable {
    let id = UUID()
    let title: String
    var items: [Annotation] = []
}


