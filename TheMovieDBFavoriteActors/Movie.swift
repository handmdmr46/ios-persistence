//
//  Movie.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/3/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class Movie {
    
    struct Keys {
        static let Title = "title"
        static let PosterPath = "poster_path"
        static let ReleaseDate = "release_date"
    }
    
    var title = ""
    var id = 0
    var posterPath : String? = nil
    var releaseDate : NSDate? = nil
    
    /**
    posterImage is a computed property.
    image cache stores the images into the documents directory
    */
    var posterImage : UIImage? {
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary[Keys.Title] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        posterPath = dictionary[Keys.PosterPath] as? String
        
        if let releaseDateString = dictionary[Keys.ReleaseDate] as? String {
            releaseDate = TheMovieDB.sharedDateFormatter.dateFromString(releaseDateString)
        }
    }
}