//
//  TheMovieDB.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/3/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

class TheMovieDB : NSObject {
    
    var session : NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
}