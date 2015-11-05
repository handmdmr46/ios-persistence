//
//  TaskCancelTableViewCell.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/5/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class TaskCancelTableViewCell : UITableViewCell {
    
    var imageName : String = ""
    
    var taskToCancelCellIfReused : NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}