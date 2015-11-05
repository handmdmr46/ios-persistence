//
//  TheMovieDBConvenience.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/4/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

// MARK: extension "TheMovieDB"

extension TheMovieDB {
    
    // MARK: convenience 
    
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
        
        let parameters = [Keys.ID : person.id]
        
        taskForResource(Resources.PersonIDMovieCredits, parameters: parameters, completionHandler: { (JSONResult, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    
                    let movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Person Parsing. Cannot find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    /*
    ** get movie id credits
    */
    func getMovieIdCredits(movie: Movie, completionHandler: (result: [Person]?, error: NSError?) -> Void) {
        
        let parameters = [Keys.ID : movie.id]
        
        
        taskForResource(Resources.MovieIDCredits, parameters: parameters, completionHandler: { (JSONResult, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    
                    let people = results.map() { Person(dictionary: $0) }
                    
                    completionHandler(result: people, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Person Parsing. Cannot find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    /*
    ** update config
    */
    func updateConfig(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = [String : AnyObject]()
        
        taskForResource(Resources.Config, parameters: parameters, completionHandler: { (JSONResult, error) in
            
            if let error = error {
                completionHandler(success: false, error: error)
            } else if let newConfig = Config(dictionary: (JSONResult as? [String : AnyObject])!){
                self.config = newConfig
                completionHandler(success: true, error: nil)
            } else {
                completionHandler(success: false, error: NSError(domain: "Update Config", code: 0, userInfo: nil))
            }
        })
    }
    
    func getKevinBaconMovieIDCredits(completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        let person = Person(dictionary: [Keys.ID : Values.KevinBaconIDValue, Person.Keys.Name : ""])
        
        getPersonIDMovieCredits(person, completionHandler: completionHandler)
    }
    
    
}









