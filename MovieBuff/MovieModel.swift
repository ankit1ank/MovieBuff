//
//  Movies.swift
//  MovieBuff
//
//  Created by Ankit Goel on 11/01/16.
//  Copyright © 2016 ankitgoel. All rights reserved.
//

import Foundation
import Unbox

struct Container: Unboxable {
    var results: [Movie]
    
    init(unboxer: Unboxer) {
        self.results = unboxer.unbox("Search")
    }
}

struct Movie: Unboxable {
    var title: String
    var year: String
    var imdbID: String
    var type: String
    var poster: String
    
    init(unboxer: Unboxer) {
        self.imdbID = unboxer.unbox("imdbID")
        self.title = unboxer.unbox("Title")
        self.year = unboxer.unbox("Year")
        self.type = unboxer.unbox("Type")
        self.poster = unboxer.unbox("Poster")
    }
}