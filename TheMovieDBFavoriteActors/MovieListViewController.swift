//
//  MovieListViewController.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/5/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {
    
    // MARK: properties
    
    var actor : Person!
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if actor.movies.isEmpty {
            
            let resource = TheMovieDB.Resources.PersonIDMovieCredits
            let parameters = [TheMovieDB.Keys.ID : actor.id]
            
            TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters, completionHandler: { (JSONResult, error) in
                
                if let error = error {
                    self.alertViewForError(error)
                } else {
                    
                    if let moviesDictionaries = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                        
                        let movies = moviesDictionaries.map() { (dictionary: [String : AnyObject]) -> Movie in
                            return Movie(dictionary: dictionary)
                        }
                        
                        self.actor.movies = movies
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    } else {
                        let error = NSError(domain: "Movie for Person Parsing. Cannot find cast in \(JSONResult)", code: 0, userInfo: nil)
                        self.alertViewForError(error)
                    }
                }
            })
        }
    }
    
    // MARK: table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actor.movies.count
    }
    
    /*
    ** The downloading of movie posters is handled here. Notice how the method uses a unique
    ** table view cell that holds on to a task so that it can be canceled.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = actor.movies[indexPath.row]
        let CellIdenifier = "MovieCell"
        var posterImage = UIImage(named: "posterPlaceholer")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdenifier) as! TaskCancelTableViewCell
        
        cell.textLabel!.text = movie.title
        cell.imageView!.image = nil
        
        /* set movie poster image */
        
        if movie.posterPath == nil || movie.posterImage == "" {
            posterImage = UIImage(named: "noImage")
        } else if movie.posterImage != nil {
            posterImage = movie.posterImage
        } else {
            
            /*
            ** This is the interesting case. The movie has an image name, but it is not downloaded yet.
            */
            
            // This first line returns a string representing the second to the smallest size that TheMovieDB serves up
            let size = TheMovieDB.sharedInstance().config.posterSizes[1]
            
            // Start the task that will eventually download the image
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: movie.posterPath!) { (data, error) in
                
                if let error = error {
                    print("poster download error: \(error.localizedDescription)")
                } else {
                    
                    if let data = data {
                        // create the image
                        let image = UIImage(data: data)
                        
                        // update the model, so that the information gets cashed
                        movie.posterImage = image
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.imageView!.image = image
                        })
                    }
                }
            }
            
            // This is the custom property on this cell. See TaskCancelingTableViewCell.swift for details.
            cell.taskToCancelCellIfReused = task
        }
        
        cell.imageView!.image = posterImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (editingStyle) {
        case .Delete:
            actor.movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
    
    
    // MARK: alert view
    
    func alertViewForError(error: NSError) {
        // A real live AlertViewController would be better...
        //TODO: add alert view controller, see commented notes in MyOnTheMapApp for map view controller findOnMap section
        print(error.localizedDescription)
    }
    
    
}