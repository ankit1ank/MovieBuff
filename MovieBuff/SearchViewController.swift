//
//  ViewController.swift
//  MovieBuff
//
//  Created by Ankit Goel on 11/01/16.
//  Copyright © 2016 ankitgoel. All rights reserved.
//

import UIKit
import SwiftHTTP
import Unbox
import SDWebImage

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var noMoviesFoundLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noMoviesFoundLabel.hidden = true
        
        // Don't show empty cell in tableview by adding footer
        moviesTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        searchBar.becomeFirstResponder()
    }
    
    
    @IBAction func historyButtonPressed(sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HistoryPopoverViewController") as! HistoryPopoverViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = vc
        presentViewController(vc, animated: true, completion:nil)
    }
    
    // MARK:- Table View Data Source & Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MoviesTableViewCell
        cell.tag = indexPath.row
        
        let url = NSURL(string: movies[indexPath.row].poster)!
        cell.posterImageView.sd_setImageWithURL(url)
        cell.movieTitle.text = movies[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("movieDetail", sender: indexPath.row)
    }
    
    // MARK:- SearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Save searched keyword to property defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if let history = defaults.objectForKey("historyArray") as? [String] {
            var tempHistory = history
            if history.count == 15 {
                tempHistory.removeLast()
                tempHistory.insert(searchBar.text!, atIndex: 0)
                defaults.setObject(tempHistory, forKey: "historyArray")
            } else {
                tempHistory.insert(searchBar.text!, atIndex: 0)
                defaults.setObject(tempHistory, forKey: "historyArray")
            }
        } else {
            defaults.setObject([searchBar.text!], forKey: "historyArray")
        }
        
        searchBar.resignFirstResponder()
        searchMovies(searchBar.text!)
    }
    
    // Hide keyboard when table scrolled
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.isEqual(moviesTableView) {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK:- Web Requests
    func searchMovies(keyword: String, page: Int = 1) {
        // Show loading indicator
        self.view.makeToastActivity(.Center)
        self.view.userInteractionEnabled = false
        
        var url = "https://www.omdbapi.com/?s=\(keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&page=\(page)"
        
        
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
            
            let searchResults: Container? = Unbox(response.data)
            if searchResults != nil && searchResults?.results.count != 0 {
                self.movies = searchResults!.results
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.noMoviesFoundLabel.hidden = true
                    self.moviesTableView.hidden = false
                    self.moviesTableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.noMoviesFoundLabel.hidden = false
                    self.moviesTableView.hidden = true
                }
            }
        }
    }
    
    // MARK:- Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetail" {
            let index = sender as! Int
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.imdbID = self.movies[index].imdbID
            detailVC.movieName = self.movies[index].title
        }
    }
}

