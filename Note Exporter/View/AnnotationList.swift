//
//  AnnotationList.swift
//  Note Exporter
//
//  Created by Alex on 2020/10/02.
//

import SwiftUI

struct AnnotationList: View {
    var book: String
    var annotations: [AnnotationListItem]
    var sort: Int
    @Binding var selection: Set<Annotation>?
    
    init(book: String, annotations: [Annotation], sort: Int, selection: Binding<Set<Annotation>?>) {
        self.book = book
        self.sort = sort
        self._selection = selection
        
        let sorted = annotations.sorted {
            if sort == 0 { return $0.date > $1.date }
            else { return $0.location < $1.location }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        dateFormatter.doesRelativeDateFormatting = true
        
        var result = [AnnotationListItem]()
        var index = -1
        for item in sorted {
            var section: String
            if(sort == 0) {
                section = dateFormatter.string(from: item.date)
            } else {
                section = item.chapter ?? ""
            }
            if index == -1 || result[index].title != section {
                index += 1
                result.append(AnnotationListItem(title: section))
                result[index].items.append(item)
            } else if result[index].title == section {
                result[index].items.append(item)
            }
        }
        self.annotations = result
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(annotations) { section in
                Section(header: SectionHeader(section: section, book: book)) {
                    
                    ForEach(section.items) { item in
                        
                        VStack(alignment: .leading) {
                            Text(item.text)
                                .font(.system(size: 16))
                                .lineLimit(3)
                                .padding(.top, 8)
                            Divider()
                                .padding(.top, 8)
                        }
                        
                    }
                    
                }
            }
        }
        .listStyle(InsetListStyle())
    }
}


struct SectionHeader: View {
    var section: AnnotationListItem
    var book: String
    
    var body: some View {
        HStack {
            Text(section.title).font(.title2)
            Spacer()
            Button(action: {
                export()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
            }.buttonStyle(PlainButtonStyle())
        }
    }
    
    func export() {
        let sorted = section.items.sorted {
            $0.location < $1.location
        }
        var result = "", lastChapter = ""
        
        for item in sorted {
            if let chapter = item.chapter {
                if chapter != lastChapter {
                    result += "# \(chapter)\n\n"
                    lastChapter = chapter
                }
            }
            result += "\(item.text)\n\n"
        }
        
        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let fileUrl = downloadsDirectory.appendingPathComponent("\(book) \(section.title).md")
        
        try! result.write(to: fileUrl, atomically: true, encoding: .utf8)
        
        NSWorkspace.shared.activateFileViewerSelecting([fileUrl])
    }
}
