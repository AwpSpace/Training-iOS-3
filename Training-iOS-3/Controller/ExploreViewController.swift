//
//  ExploreViewController.swift
//  Training-iOS-3
//
//  Created by Tuan Hai on 7/5/16.
//  Copyright © 2016 Awpspace. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ExploreViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var inputKeyWord: UITextField!
    @IBOutlet weak var flickrPhotosCollection: UICollectionView!
    
    var jsonResponse:String = ""
    var items:Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPhotos(sender: AnyObject) {
        //Check nil
        var searchKeyWord:String
        if (inputKeyWord.text!.isEmpty)
        {
            searchKeyWord = "love"
        }
        else
        {
            searchKeyWord = inputKeyWord.text!
        }
        
        print("Search key word: "+searchKeyWord)
        
        //Call api
        let URL:String = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags="+searchKeyWord
        Alamofire.request(.GET, URL)
            .responseString { response in
                /*
                 print(response.request)  // original URL request
                 print(response.response) // URL response
                 print(response.data)     // server data
                 print(response.result)   // result of response serialization
                 */
                var jsonString:String = response.result.value!
                
                jsonString = jsonString.substringWithRange(Range<String.Index>(start: jsonString.startIndex.advancedBy(15), end: jsonString.endIndex.advancedBy(-1)))
                
                self.jsonResponse = jsonString
                self.parseJsonResponse()
        }
    }
    
    func parseJsonResponse(){
        print("JSON: "+jsonResponse)
        
        // convert String to NSData
        let data: NSData = jsonResponse.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            // convert NSData to 'AnyObject'
            let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                print("Parse json successful!")
                self.items = (dictionary["items"] as? Array)!
                self.loadCollectionView()
            }
        } catch{
            print("Error, Could not parse the JSON request: ")
        }
    }
    
    func loadCollectionView(){
        flickrPhotosCollection.dataSource = self
        flickrPhotosCollection.delegate = self
    }
    
    
    //UICollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPhotoCell", forIndexPath: indexPath) as! ExplorePhotoCollectionViewCell
        let item:AnyObject = items[indexPath.row]
        let link = item["link"] as? String
        c.flickrPhoto.kf_setImageWithURL(NSURL(string: link!)!)
        return c
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
