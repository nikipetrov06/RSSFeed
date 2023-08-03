//
//  DetailsView.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 02/08/2023.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    let title: String
    let description: String
    let imageURL: String
    let link: String
    
    var body: some View {
        VStack {
            KFImage(URL(string: imageURL))
                .resizable()
                .aspectRatio(10, contentMode: .fit)
            Text(title)
                .bold()
                .padding([.bottom, .leading, .trailing])
            Text(description)
                .padding([.bottom, .leading, .trailing])
            if let link = URL(string: link) {
                Link("Read more",
                     destination: link)
                    .padding([.leading, .trailing])
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(title: "Title",
                    description: "Text",
                    imageURL: "",
                    link: "google.com")
    }
}
