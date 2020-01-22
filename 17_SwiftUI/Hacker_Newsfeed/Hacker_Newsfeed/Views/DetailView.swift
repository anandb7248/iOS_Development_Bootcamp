//
//  DetailView.swift
//  Hacker_Newsfeed
//
//  Created by Anand Batjargal on 1/21/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
