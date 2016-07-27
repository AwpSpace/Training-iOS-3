//
//  ExplorePhotoCollectionViewCell.swift
//  Training-iOS-3
//
//  Created by Tuan Hai on 6/20/16.
//  Copyright © 2016 Awpspace. All rights reserved.
//
import Foundation
import UIKit

class ExplorePhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!

    var url: String!
    
    enum ErrorHandling:ErrorType
    {
        case NetworkError
    }
    
    func  setImageUrl(url: String){
        self.url = url
        
        loadImage(url)
    }
    
    func loadImage(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func displayImage()
                {
                    //print("display: \(self.url)")
                    self.photo.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), displayImage)
            }
            
        }
        
        task.resume()
    }
}
