//
//  MovieDetailModel.swift
//  MovieBuff
//
//  Created by Ankit Goel on 12/01/16.
//  Copyright © 2016 ankitgoel. All rights reserved.
//

import Foundation
import Unbox

struct MovieDetails: Unboxable {
    var title: String
    var year: String
    var rated: String
    var released: String
    var runtime: String
    var genre: String
    var director: String
    var writer: String
    var actors: String
    var plot: String
    var language: String
    var country: String
    var awards: String
    var poster: String
    var metascore: String
    var imdbRating: String
    var imdbVotes: String
    var imdbID: String
    var type: String
    var response: String
    
    
    init(unboxer: Unboxer) {
        self.title = unboxer.unbox("Title")
        self.year = unboxer.unbox("Year")
        self.rated = unboxer.unbox("Rated")
        self.released = unboxer.unbox("Released")
        self.runtime = unboxer.unbox("Runtime")
        self.genre = unboxer.unbox("Genre")
        self.director = unboxer.unbox("Director")
        self.writer = unboxer.unbox("Writer")
        self.actors = unboxer.unbox("Actors")
        self.plot = unboxer.unbox("Plot")
        self.language = unboxer.unbox("Language")
        self.country = unboxer.unbox("Country")
        self.awards = unboxer.unbox("Awards")
        self.poster = unboxer.unbox("Poster")
        self.metascore = unboxer.unbox("Metascore")
        self.imdbRating = unboxer.unbox("imdbRating")
        self.imdbVotes = unboxer.unbox("imdbVotes")
        self.imdbID = unboxer.unbox("imdbID")
        self.type = unboxer.unbox("Type")
        self.response = unboxer.unbox("Response")
        
    }
}