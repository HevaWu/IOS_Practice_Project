
//
//  Music.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/11.
//  Copyright © 2017 He Wu. All rights reserved.
//

import UIKit
import os.log
import FLAnimatedImage
import SDWebImage


//the Music class's initializer must call one of the NSObject class's designated initializers
//the NSObject class's only initializer is init()
class Music: NSObject, Codable {
    
    //Mark: Properties
    //using var because they'll need to change throughout the course of a Meal object's lifetime
    var name: String
    var photo: UIImage?
    var rating: Int
    var animatedImage: FLAnimatedImage?
    var photoURLString: String?
    var isGif: Bool = false
    
    //Mark func properties
//    public var photoURLString: String {
//        get{
//            return objc_getAssociatedObject(self, &PropertyKey.photoURLString) as? String ?? ""
//        }
//        set{
//            objc_setAssociatedObject(self, &PropertyKey.photoURLString, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    public var isGif: Bool{
//        get {
//            //return self.photoURLString.isEmpty == false
//            //return self.photoURLString.lowercased().hasSuffix(".gif")
//            return objc_getAssociatedObject(self, &self.isGif) as? Bool ?? false
//        }
//        set {
//            objc_setAssociatedObject(self, &self.isGif, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    public var photoDiskPath: String{
//        get{
//            return objc_getAssociatedObject(self, &self.photoDiskPath) as? String ?? ""
//        }
//        set {
//            objc_setAssociatedObject(self, &self.photoDiskPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
    
    //Mark: Archiving Paths
    //static, means they belong to the class instead of an instance of the class
    //outside of the Music class, access the path using Music.ArchiveURl.path
    //There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
    //DocumentsDirectory is a directory where your app can save data for the user, return an array of URLs
    //After determining the URL for the documents directory, you use this URL to create the URL for your apps data. Here, create the file URL by appending musics to the end of the documents URL.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("musics.json")
    
    //Mark: Types
    enum CodingKeys: String, CodingKey{
        case name = "name"
        case rating = "rating"
        case photoURLString = "photoURLString"
    }
    
    //Mark: Initialization
    //prepare the instance of a class, involves setting an initial value for each property and preforming any other setup or initialization
    //Failable initializers always start with init? or init!
    //return optional values or implicitly unwrapped optional values
    init?(name: String, rating: Int, photoURLString: String?) {
        //Initialization shoulf fail if there is no name of if the rating is negative
        /*if name.isEmpty || rating < 0 {
         return nil
         }*/
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        //The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //Initialize store properties
        //fill out the basic implementation by setting the properties equal to the parameter values
        self.name = name
        //self.photo = photo
        self.rating = rating
        
        self.photoURLString = photoURLString!
    }
    
    //Mark: Codable
    func encode(to encoder: Encoder) throws {
        //encode data of the given type
        //first two lines pass a String, the third line pass Int, the fourth line pass String
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(rating, forKey: CodingKeys.rating)
        try container.encode(photoURLString, forKey: CodingKeys.photoURLString)
    }
    //convenience means this is a secondary initializer
    //? means this is a failable initializer that might return nil
    //required convenience init?(coder aDecoder: NSCoder) {
    required convenience init(from decoder: Decoder) throws {
        //The name is required. if we cannot decode a name string, the initializer should fail
        //decodeObject() decode encoded information
        //guard statement both unwraps the optional and downcasts the enclosed type to a String, before assigning it to the name constant
        //if either of these operations fail, the entire initializer fails
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let name = try values.decode(String.self, forKey: CodingKeys.name)
        let rating = try values.decode(Int.self, forKey: CodingKeys.rating)
        let photoURLString = try values.decode(String.self, forKey: CodingKeys.photoURLString)
        
        //Must call designated initializer
        self.init(name: name, rating: rating, photoURLString: photoURLString)!
        fla_setImageWithURLString(URLString: photoURLString)
    }
    
    //Mark: functions
    //set the image with URL, and check if this image is already in the cache, if not, download the data and extract the image
    public func fla_setImageWithURLString(URLString: String?){
//        self.photo = placeholder!
        
        if URLString == "" {return}
        
        guard let imageURL = NSURL(string: URLString!) ?? URLEncoded(string: URLString!) else {
            print("URL error")
            return
        }

        self.photoURLString = URLString!
        self.isGif = (self.photoURLString?.lowercased().hasSuffix(".gif"))!
        
        let manager = SDWebImageManager.shared()
        let memoryImage = manager.imageCache?.imageFromMemoryCache(forKey: URLString)
        let diskImage = manager.imageCache?.imageFromDiskCache(forKey: URLString)
        
        guard let cacheImage = memoryImage ?? diskImage else {
            if isGif {
                self.fla_downloadImageWithURL(URL: imageURL)
            } else {
                self.fla_downloadImageWithDirectory(URLString: URLString!)
            }
            return
        }
        if isGif == false {return}
//        let imageData = NSData(contentsOfFile: self.photoURLString!)
        let imageData = NSData(contentsOf: URL(string: self.photoURLString!)!)
        guard imageData != nil else {
            print("Photo Data is nil")
            return
        }
        guard let finalURL = self.photoURLString as String? else {
            return
        }
        if finalURL == URLString {
            self.setImageSource(GIFData: imageData, image: cacheImage)
        }
    }

    //Mark: Private
    //encoding url
    private func URLEncoded(string URLString: String) -> NSURL? {
        guard let URLEncodingString = URLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return nil
        }
        return NSURL(string: URLEncodingString)
    }
    private func fla_downloadImageWithURL(URL: NSURL) {
        let downloader: SDWebImageDownloader = SDWebImageDownloader.shared()
        downloader.downloadImage(
            with: URL as URL,
            options: SDWebImageDownloaderOptions.progressiveDownload,
            progress: nil,
            completed: {[weak self] (image: Optional<UIImage>, originalData: Optional<Data>, error: Optional<Error>, finished: Bool) in
                guard error == nil && finished else{return}
                guard image != nil || originalData != nil else {return}
                guard let newImage = image else {return}
                //when object is nil, return
                if(self == nil) {return}
                guard let finalURL = self?.photoURLString as String? else {return}
                
                SDWebImageManager.shared().imageCache?.store(newImage, forKey: finalURL, toDisk: true)
                if finalURL == URL.absoluteString {
                    self!.setImageSource(GIFData: originalData as NSData?, image: image)
                }
        })
    }
    private func fla_downloadImageWithDirectory(URLString: String){
        let image = UIImage(contentsOfFile: URLString)
        SDWebImageManager.shared().imageCache?.store(image, forKey: URLString, toDisk: true)
        self.setImageSource(GIFData: nil, image: image)
    }
    private func setImageSource(GIFData: NSData? = nil, image: UIImage? = nil){
//        DispatchQueue.main.async {
        
        if self.isGif {
            self.animatedImage = FLAnimatedImage(gifData: GIFData! as Data)
            self.photo = nil
        } else {
            self.photo = image
            self.animatedImage = nil
        }

    }
    private func loadJson(finishedClosure:@escaping ((_ jsonObject:[String:AnyObject]?, _ error:NSError?)->Void)){
        DispatchQueue.global().async {
            guard let filePath = Bundle.main.path(forResource: "JsonData/music", ofType: "json") else {
                DispatchQueue.main.async {
                    finishedClosure(nil, NSError(domain: "Cannot find Json file", code: 998, userInfo: nil))
                }
                return
            }
            guard let fileData = (try? Data(contentsOf: URL(fileURLWithPath: filePath))) else {
                DispatchQueue.main.async {
                    finishedClosure(nil, NSError.init(domain: "Cannot find Json data", code: 999, userInfo: nil))
                }
                return
            }
            do{
                if let jsonObject = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] {
                    DispatchQueue.main.async {
                        finishedClosure(jsonObject,nil)
                    }
                }
            } catch let error as NSError {
                print(error)
                DispatchQueue.main.async {
                    finishedClosure(nil, error)
                }
            }
        }
    }
}
