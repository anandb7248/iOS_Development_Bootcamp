//
//  PostData.swift
//  Hacker_Newsfeed
//
//  Created by Anand Batjargal on 1/20/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let title: String?
    let points: Int?
    let url: String?
}
