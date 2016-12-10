//
//  ImageDownloader.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/4/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class ImageDownloader {
    class func downloadImage(avatarURL : String) -> (UIImage?) {
        let imageURL = URL(string: avatarURL)
        do {
            let imageData = try Data(contentsOf: imageURL!)
            if let image = UIImage(data: imageData) {
                let size = determineProfileImageSize()
                let resizedImage = resizeImage(image: image, size: size)
                return resizedImage
            }
        } catch {
            print("Unable to download image)")
            return nil
        }
        return nil
    }
    
    class func determineProfileImageSize() -> CGSize {
        var size : CGSize
        switch UIScreen.main.scale {
        case 2:
            size = CGSize(width: 160, height: 160)
        case 3:
            size = CGSize(width: 240, height: 240)
        default:
            size = CGSize(width: 80, height: 80)
        }
        return size
    }
    
    class func resizeImage(image : UIImage, size : CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
