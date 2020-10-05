//
//  Annotation.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/29.
//

import Foundation
import GRDB

struct Annotation: Identifiable, Hashable {
    let id = UUID()
    let bookId: String
    let text: String
    let chapter: String?
    let date: Date
    let location: String
}

extension Annotation: FetchableRecord {
    enum Columns: String, ColumnExpression {
        case bookId = "ZANNOTATIONASSETID"
        case text = "ZANNOTATIONSELECTEDTEXT"
        case chapter = "ZFUTUREPROOFING5"
        case date = "ZANNOTATIONMODIFICATIONDATE"
        case location = "ZANNOTATIONLOCATION"
    }
    
    init(row: Row) {
        bookId = row[Columns.bookId]
        text = row[Columns.text]
        chapter = row[Columns.chapter]
        date = String(row[Columns.date]).toDate()
        location = row[Columns.location]
    }
}

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        return formatter.date(from: self)!
    }
}
