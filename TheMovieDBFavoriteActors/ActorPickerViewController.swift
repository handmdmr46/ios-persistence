//
//  ActorPickerViewController.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/5/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

/**
* actors -> The data for the table
* delegate -> The delegate will typically be a view controller, waiting for the Actor Picker to return an actor
* searchTask -> The most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
*
*/

import UIKit

// MARK: protocol

protocol ActorPickerViewControllerDelegate {
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?)
}

// MARK: view controller

class ActorPickerViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: properties
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var actors = [Person]()
    var delegate : ActorPickerViewControllerDelegate?
    var searchTask : NSURLSessionDataTask?
    
    // MARK: life cycle

    override func viewDidLoad() {
        //super.viewDidLoad() //removed this, why? maybe forgot??
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonTouchUp")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    // MARK: actions
    
    @IBAction func cancelButtonTouchUp() {
        self.delegate?.actorPicker(self, didPickActor: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: search bar delegate functions
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        /* cancel last task */
        if let task = searchTask {
            task.cancel()
        }
        
        /* if search text empty then we're done */
        if searchText == "" {
            actors = [Person]()
            tableView?.reloadData()
            objc_sync_exit(self)
            return
        }
        
        /* start query */
        let resource = TheMovieDB.Resources.SearchPerson
        let parameters = ["query" : searchText]
        
        /* lets try both, not sure what this "[unowned self]" means - I dont like the syntax of it so will avpoid if I can */
        //searchTask = TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters, completionHandler: {  [unowned self] JSONResult, error  in
        searchTask = TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters, completionHandler: {  (JSONResult, error)  in
            
            if let error = error {
                print("Error searching for actors: \(error.localizedDescription)")
                return
            }
            
            if let actorDictionaries = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                
                self.searchTask = nil
                
                self.actors = actorDictionaries.map() { Person(dictionary: $0) }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            }
        })
    }
    
    // MARK: table view delegate functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellReuseID = "ActorSearchCell"
        let actor = actors[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseID)!
        cell.textLabel!.text = actor.name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let actor = actors[indexPath.row]
        delegate?.actorPicker(self, didPickActor: actor)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}












