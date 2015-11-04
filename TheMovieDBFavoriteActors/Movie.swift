//
//  Movie.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/3/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

class Movie {
    
    struct Keys {
        static let Title = "title"
        static let PosterPath = "poster_path"
        static let ReleaseDate = "release_date"
    }
    
    var title = ""
    var id = 0
    var posterPath : String? = nil
    var releaseDate : String? = nil
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary[Keys.Title] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        posterPath = dictionary[Keys.PosterPath] as? String
        
        if let releaseDateString = dictionary[Keys.ReleaseDate] as? String {
            //releaseDate = TheMovieDB.sharedDateFormatter.dateFromString(releaseDateString)
        }
    }
    
    /**
    posterImage is a computed property.
    image cache stores the images into the documents directory
    */
    
    
}