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
    
    // MARK: life cycle
    
    // MARK: table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
    
    // MARK: alert view
    
    func alertViewForError(error: NSError) {
        // A real live AlertViewController would be better...
        //TODO: add alert view controller, see commented notes in MyOnTheMapApp for map view controller findOnMap section
        print(error.localizedDescription)
    }
}