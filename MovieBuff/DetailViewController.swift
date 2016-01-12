//
//  DetailViewController.swift
//  MovieBuff
//
//  Created by Ankit Goel on 11/01/16.
//  Copyright © 2016 ankitgoel. All rights reserved.
//

import UIKit
import SwiftHTTP
import Unbox

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    // Labels for movie details
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    var imdbID: String = ""
    var movieName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = movieName
        movieNameLabel.text = movieName
        
        getMovieDetails(imdbID)
    }
    
    // MARK:- Web Requests
    func getMovieDetails(imdbID: String) {
        // Show loading indicator
        self.view.makeToastActivity(.Center)
        self.view.userInteractionEnabled = false
        
        var url = "https://www.omdbapi.com/?i=\(imdbID.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)"
        
        let req = try! HTTP.GET(url)
        req.start { response in
            
            // Hide toast when data fetched
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideToastActivity()
                    self.view.userInteractionEnabled = true
                }
            }
            
            guard response.error == nil else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(response.error!.localizedDescription, duration: 3.0, position: .Center)
                }
                return
            }
            
            let movie: MovieDetails = Unbox(response.data)!
            //print(movie)
            dispatch_async(dispatch_get_main_queue()) {
                self.posterImageView.sd_setImageWithURL(NSURL(string: movie.poster)!)
                self.yearLabel.text = "Year: " + movie.year
                self.runtimeLabel.text = "Runtime:" + movie.runtime
                self.ratedLabel.text = "Rated: " + movie.rated
                self.genreLabel.text = "Genre: " + movie.genre
                self.directorLabel.text = "Director: " + movie.director
                self.writerLabel.text = "Writer: " + movie.writer
                self.actorsLabel.text = "Actors: " + movie.actors
                self.plotLabel.text = "Plot: " + movie.plot
            }
            
        }
    }
}
