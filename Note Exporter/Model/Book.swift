//
//  Book.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/29.
//

import Foundation
import GRDB

struct Book {
    var bookId: String
    var title: String
    var author: String?
    
    var lastModified = Date(timeIntervalSince1970: 0)
    var annotations = [Annotation]()
    
    var hasAnnotation: Bool {
        !self.annotations.isEmpty
    }
}

extension Book: FetchableRecord {
    enum Columns: String, ColumnExpression {
        case bookId="ZASSETID"
        case title="ZTITLE"
        case author = "ZAUTHOR"
    }
    
    init(row: Row) {
        bookId = row[Columns.bookId]
        title = row[Columns.title]
        author = row[Columns.author]
    }
}
