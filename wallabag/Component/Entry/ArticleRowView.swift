//
//  ArticleRowView.swift
//  wallabag
//
//  Created by Marinel Maxime on 17/07/2019.
//

import SwiftUI

struct ArticleRowView: View {
    @Binding var entry: Entry

    var body: some View {
        HStack {
            // NetworkImage(imageURL: entry.previewPicture?.url, placeholderImage: UIImage(systemName: "book")!)
            //     .frame(width: 50, height: 50, alignment: .center)
            VStack(alignment: .leading) {
                Text(entry.title ?? "")
                    .font(.headline)
                Text(String(format: "Reading time %@".localized, arguments: [Int(entry.readingTime).readingTime]))
                    .font(.footnote)
                HStack {
                    EntryPictoImage(entry: $entry, keyPath: \.isArchived, picto: "book")
                    EntryPictoImage(entry: $entry, keyPath: \.isStarred, picto: "star")
                    Text(entry.domainName ?? "")
                        .font(.footnote)
                }
            }
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(entry: .constant(Entry())).previewLayout(.fixed(width: 300, height: 70))
    }
}
