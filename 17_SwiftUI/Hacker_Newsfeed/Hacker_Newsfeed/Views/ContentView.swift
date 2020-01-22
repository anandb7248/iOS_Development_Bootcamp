//
//  ContentView.swift
//  Hacker_Newsfeed
//
//  Created by Anand Batjargal on 1/20/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.posts) {post in
                NavigationLink(destination: DetailView(url: post.url)) {
                    HStack{
                        Text(String(post.points!))
                        Text(post.title!)
                    }
                }
            }.navigationBarTitle("H4X0R News")
        }.onAppear {
                self.networkManager.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
