//
//  BookStore.swift
//  Note Exporter
//
//  Created by Alex on 2020/09/29.
//

import Foundation
import GRDB

class BookStore: ObservableObject {
    @Published var books = [Book]()
    var titles: [String] {
        return books.map { $0.title }
    }
    
    init() {
        load()
    }
    
    func load() {
        DispatchQueue.main.async {
            let res = self.loadBooks()
            self.books = res.sorted {
                $0.lastModified > $1.lastModified
            }
        }
    }
    
    func loadSidebar() -> [SidebarItem] {
        return self.titles.map { SidebarItem(name: $0) }
    }
    
    private func loadBooks() -> [Book] {
        let directory = try! FileManager.default.url(
                for: .libraryDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            .appendingPathComponent("Containers/com.apple.iBooksX/Data/Documents/BKLibrary")
        
        let contents = try? FileManager.default.contentsOfDirectory(atPath: directory.path)
        guard let files = contents else {
            return []
        }
        
        var fileName = ""
        for file in files {
            if file.hasSuffix("sqlite") {
                fileName = file
            }
        }
        let fullPath = directory.appendingPathComponent(fileName)
        
        let dbQueue = try! DatabaseQueue(path: fullPath.absoluteString)
        
        let results = try! dbQueue.read { db in
            try Book.fetchAll(db, sql: "select distinct(ZASSETID), ZTITLE, ZAUTHOR from ZBKLIBRARYASSET")
        }
        
        return loadAnnotations(results)
    }
    
    
    private func loadAnnotations(_ books: [Book]) -> [Book] {
        let directory = try! FileManager.default.url(
                for: .libraryDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            .appendingPathComponent("Containers/com.apple.iBooksX/Data/Documents/AEAnnotation")
        
        let contents = try? FileManager.default.contentsOfDirectory(atPath: directory.path)
        guard let files = contents else {
            return []
        }
        
        var fileName = ""
        for file in files {
            if file.hasSuffix("sqlite") {
                fileName = file
            }
        }
        let fullPath = directory.appendingPathComponent(fileName)
        
        let dbQueue = try! DatabaseQueue(path: fullPath.absoluteString)

        let result = try? dbQueue.read { db in
            try Annotation.fetchAll(db, sql: "SELECT datetime(ZANNOTATIONMODIFICATIONDATE,'unixepoch','localtime','+31 year') as ZANNOTATIONMODIFICATIONDATE, ZANNOTATIONASSETID, ZANNOTATIONLOCATION, ZANNOTATIONSELECTEDTEXT, ZFUTUREPROOFING5 FROM ZAEANNOTATION WHERE ZANNOTATIONSELECTEDTEXT not NULL AND ZANNOTATIONDELETED != 1")
        }
        guard let annotations = result else {
            return []
        }
        
        var books = books
        for item in annotations {
            if let i = books.firstIndex(where: { $0.bookId == item.bookId }) {
                books[i].annotations.append(item)
                if item.date > books[i].lastModified {
                    books[i].lastModified = item.date
                }
            }
        }
        books = books.filter({ $0.hasAnnotation })
        
        return books
    }
}
