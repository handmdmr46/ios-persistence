//
//  Config.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/4/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

/**
* The config struct stores information that is used to build image
* URL's for TheMovieDB. The constant values below were taken from
* the site on 1/23/15. Invoking the updateConfig convenience method
* will download the latest using the failable initializer below to
* parse the dictionary.
*/

// MARK: file support url constants

private let DocumentsDirectoryURL : NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
private let FileURL : NSURL = DocumentsDirectoryURL.URLByAppendingPathComponent("TheMovieDB-Context")

class Config : NSObject/*, NSCoding*/ {
    
    // MARK: properties
    
    var baseImageURLString = "http://image.tmdb.org/t/p/"
    var secureBaseImageURLString = "https://image.tmdb.org/t/p/"
    var posterSizes = ["w92", "w154", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    var dateUpdated : NSDate? = nil
    
    var daysSinceUpdate : Int? {
        if let lastUpdate = dateUpdated {
            return Int(NSDate().timeIntervalSinceDate(lastUpdate)) / 60*60*24
        } else {
            return nil
        }
    }
    
    override init() {}
    
    convenience init?(dictionary: [String : AnyObject]) {
        self.init()
        
        if let imageDictionary = dictionary[TheMovieDB.Keys.ConfigImages] as? [String : AnyObject] {
            
            if let urlString = imageDictionary[TheMovieDB.Keys.ConfigBaseImageURL] as? String {
                baseImageURLString = urlString
            } else {
                return nil
            }
            
            if let secureUrlString = imageDictionary[TheMovieDB.Keys.ConfigSecureBaseImageURL] as? String {
                secureBaseImageURLString = secureUrlString
            } else {
                return nil
            }
            
            if let posterSizesArray = imageDictionary[TheMovieDB.Keys.ConfigPosterSizes] as? [String] {
                posterSizes = posterSizesArray
            } else {
                return nil
            }
            
            if let profileSizesArray = imageDictionary[TheMovieDB.Keys.ConfigProfileSizes] as? [String] {
                profileSizes = profileSizesArray
            } else {
                return nil
            }
            
            dateUpdated = NSDate()
        } else {
            return nil
        }
    }
    
    // MARK: helper
    
    func updateIfDaysSinceUpdateExcceeds(days: Int) {
        
        if let daysSinceUpdate = daysSinceUpdate {
            if (daysSinceUpdate <= days) {
                return
            }
        }
    }
    
    // MARK: nscoding properties
    
    let BaseImageURLStringKey = "config.base_image_url_string_key"
    let SecureBaseImageURLStringKey = "config.secure_base_image_url_key"
    let PosterSizesKey = "config.poster_size_key"
    let ProfileSizesKey = "config.profile_size_key"
    let DateUpdatedKey = "config.date_update_key"
    
    // MARK: nscoding protocol
    
    required init?(coder aDecoder: NSCoder) {
        baseImageURLString = aDecoder.decodeObjectForKey(BaseImageURLStringKey) as! String
        secureBaseImageURLString = aDecoder.decodeObjectForKey(SecureBaseImageURLStringKey) as! String
        posterSizes = aDecoder.decodeObjectForKey(PosterSizesKey) as! [String]
        profileSizes = aDecoder.decodeObjectForKey(ProfileSizesKey) as! [String]
        dateUpdated = aDecoder.decodeObjectForKey(DateUpdatedKey) as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(baseImageURLString, forKey: BaseImageURLStringKey)
        aCoder.encodeObject(secureBaseImageURLString, forKey: SecureBaseImageURLStringKey)
        aCoder.encodeObject(posterSizes, forKey: PosterSizesKey)
        aCoder.encodeObject(profileSizes, forKey: ProfileSizesKey)
        aCoder.encodeObject(dateUpdated, forKey: DateUpdatedKey)
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: FileURL.path!)
    }
    
    class func unarchiverInstance() -> Config? {
        if NSFileManager.defaultManager().fileExistsAtPath(FileURL.path!) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(FileURL.path!) as? Config
        } else {
            return nil
        }
    }
}

















