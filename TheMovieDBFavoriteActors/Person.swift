//
//  Person.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/4/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class Person {
    
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }
    
    var name = ""
    var id = 0
    var imagePath = ""
    var movies = [Movie]()
    
    var image : UIImage? {
        
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath)
        }
    }
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary[Keys.Name] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        
        if let pathForImage = dictionary[Keys.ProfilePath] as? String {
            imagePath = pathForImage
        }
    }
}
