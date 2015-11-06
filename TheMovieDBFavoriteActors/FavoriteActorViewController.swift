//
//  FavoriteActorViewController.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/5/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class FavoriteActorViewController : UITableViewController, ActorPickerViewControllerDelegate {
    
    // MARK: properties
    
    var actors = [Person]()
    
    // MARK: persistence - save the favorite actors array
    
    var actorArrayURL : NSURL {
        let filename = "favoriteActorsArray"
        let documentsDirectoryURL : NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        return documentsDirectoryURL.URLByAppendingPathComponent(filename)
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addActorButtonTouchUp")
    }
    
    // MARK: actions
    
    @IBAction func addActorButtonTouchUp() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ActorPickerViewController") as! ActorPickerViewController
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: actor picker delegate
    
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?) {
        
        if let newActor = actor {
            
            for a in actors {
                if a.id == newActor.id {
                    return
                }
            }
            
            self.actors.append(newActor)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let actor = actors[indexPath.row]
        let CellIdentifier = "ActorCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActorTableViewCell
        
        cell.nameLabel!.text = actor.name
        cell.frameImageView.image = UIImage(named: "personFrame")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if let localImage = actor.image {
            cell.actorImageView.image = localImage
        } else if actor.imagePath == "" {
            cell.actorImageView.image = UIImage(named: "personNoImage")
        } else {
            /* If the above cases don't work, then download the image */
            
            cell.actorImageView.image = UIImage(named: "personPlaceholder")
            
            let size = TheMovieDB.sharedInstance().config.profileSizes[1]
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: actor.imagePath, completionHandler: { (data, error) in
                
                if let error = error {
                    print("Image Path error: \(error.localizedDescription)")
                }
                
                if let data = data {
                    dispatch_async(dispatch_get_main_queue(), {
                        let image = UIImage(data: data)
                        actor.image = image
                        cell.actorImageView.image = image
                    })
                }
            })
           
            cell.taskToCancelCellIfReused = task
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MovieListViewController") as! MovieListViewController
        vc.actor = actors[indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            actors.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
}
