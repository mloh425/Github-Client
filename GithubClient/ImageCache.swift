//
//  ImageCache.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/9/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class ImageCache {
    var cache = [String : UIImage]()
    static let sharedCache = ImageCache()
    private init() {}
    
    func findImage(name : String) -> UIImage? {
        if let image = cache[name] {
            return image
        }
        return nil
    }
    
    func addImage(name : String, image : UIImage) {
        cache[name] = image
    }
}
