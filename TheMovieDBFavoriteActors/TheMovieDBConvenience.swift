//
//  TheMovieDBConvenience.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/4/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

extension TheMovieDB {
    
    /*
    ** get movies for search string
    */
    func getMoviesForSearchString(searchString: String, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        let parameters = ["query" : searchString]
        
        taskForResource(Resources.SearchMovie, parameters: parameters, completionHandler: { (JSONResult, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                    
                    let movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie Parsing", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    /*
    ** get movies for genre
    */
    func getMoviesForGenreID(genre: String, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        let parameters = [Keys.ID : genre]
        
        taskForResource(Resources.GenreIDMovies, parameters: parameters, completionHandler: { (JSONResult, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                    
                    let movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Genre Parsing. Cant find results in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    /*
    ** get movies for person
    */
    func getPersonIDMovieCredits(person: Person, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        
        
    }
    
    
    
    
    
}









