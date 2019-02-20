//
//  Category.swift
//  Todoey
//
//  Created by Anand Batjargal on 2/17/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHexVal: String = ""
    let items = List<Item>()
}
