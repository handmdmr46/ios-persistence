//
//  ImageCache.swift
//  TheMovieDBFavoriteActors
//
//  Created by martin hand on 11/3/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class ImageCache {
    
    private var inMemoryCache = NSCache()
    
    // MARK: retreive images
    
    /*
    ** (1) try the memory cache (2) try the hard drive
    */
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // (1)
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // (2)
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: save images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {

        let path = pathForIdentifier(identifier)
        
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            return
        }
    }
    
    
    // MARK: helper function
    
    func pathForIdentifier(identifier: String) -> String {
        let documentDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}