//
//  MusicTableViewController.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/12.
//  Copyright © 2017 He Wu. All rights reserved.
//

import os.log
import UIKit
import SDWebImage
import FLAnimatedImage
//import Photos

class MusicTableViewController: UITableViewController {
    //Mark: Properties
//    var musics = Musics.init()
    var musics = [Music]()
    let imageView = SDWebImageManager()
//    var musicJson: Any? = nil

    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //load data local
        //Load any saved musics, otherwise load sample data
//        if let savedMusics = loadMusics() {
//            //if successfully returns an array of Music objects, return true
//            //if return nil, no musics load
//            musics += savedMusics
////            musics.addMusic(musics: savedMusics)
//        } else {
//            //Load the sample data
//            loadSampleMusics()
//        }
        
        //load data by url server
        getDataFromMockServer{savedMusics in
            self.checkURLMusics(savedMusics: savedMusics!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.musics)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //Make table view show 1 section instead of 0
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //return the number of musics you have
        return musics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Table view cells are reused and should be dequeued using a cell identifies
        //create a constant with the identifier you set in the storyboard
        let cellIdentifier = "MusicTableViewCell"
        
        //dequeueReusableCell() requests a cell from the table view
        //tries to reuse the cells when possible
        //if not cells available, instantiates a new one
        //The as? MealTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your MealTableViewCell class. This returns an optional.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicTableViewCell else {
            fatalError("The dequeued cell is not an instance of MusicTableViewCell.")
        }
        
        //Fetches the appropriate music for the data source layout
        let music = musics[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = music.name
        if music.isGif {
            //show the animate image
            //let photoURLString = music.photoURLString
            //let photoURL =  URL(string: photoURLString)
            //let photoData = NSData(contentsOf: photoURL!)
            //let photoImage = FLAnimatedImage(gifData: photoData! as Data)
            cell.photoImageView.animatedImage = music.animatedImage

            //print("animated photo load successfully!")
        } else {
            cell.photoImageView.image = music.photo
        }
        //cell.photoImageView.image = music.photo
        cell.ratingControl.rating = music.rating

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //remove the music object to be deleted from musics
            musics.remove(at: indexPath.row)
            
            //Save the musics
            saveMusics()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        //if the identifier is nil, ?? replaces it with ""
        switch (segue.identifier ?? "") {
        case "AddItem":
            //if user adding an item to the meal list, do not need to change the meal detail scene's appearance
            //log a simple debug message to the console
            os_log("Adding a new meal", log: OSLog.default, type:.debug)
        case "ShowDetail":
            guard let musicDetailViewController = segue.destination as? MusicViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMusicCell = sender as? MusicTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMusicCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMusic = musics[indexPath.row]
            musicDetailViewController.music = selectedMusic
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    //Mark: Actions
    @IBAction func unwindToMusicList(sender: UIStoryboardSegue){
        //use as? to downcast the segue's source view controller to a MusicViewController instance
        //return optional value, maybe nil
        //if success, assign an instance to the local constant sourceViewController, and check if the music property is nil
        //if non-nil, assign the value of that property to the local constant music and executes the if
        if let sourceViewController = sender.source as? MusicViewController, let music = sourceViewController.music {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //checks whether a row in the table view is selected
                //if it is, user tapped one of the table view cells to edit a music, executed when editing an existing music
                //Update an existing music
                //replace the old one
                musics[selectedIndexPath.row] = music
                //reload the appropriate row in the table view
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                //Add a new music
                let newIndexPath = IndexPath(row: musics.count, section: 0)
                musics.append(music)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the musics
            saveMusics()
        }
    }
    
    //Mark: Private Methods
    private func loadSampleMusics(){
        //load music images
        let photo1URLString = Bundle.main.path(forResource: "Guitar", ofType: "jpeg")
        let photo2URLString = Bundle.main.path(forResource: "Electronic", ofType: "jpeg")
        let photo3URLString = Bundle.main.path(forResource: "Earphone", ofType: "jpeg")
        let photo4URLString = Bundle.main.path(forResource: "Mark", ofType: "jpeg")
        let photo5URLString = Bundle.main.path(forResource: "Colorful", ofType: "jpeg")
        let photo6URLString = Bundle.main.path(forResource: "Black", ofType: "jpeg")

//        let photo1 = UIImage(named: "music1")
        
        let photo8String = "https://hddfhm.com/images/animated-clipart-freeware-6.gif"
//        let photoURL = URL(string: photo8String)!
//        let photoData = try! Data(contentsOf: photoURL)
//        let photo8 = FLAnimatedImage(gifData: photoData)
        
        //create music objects
        guard let music1 = Music(name: "Guitar", rating: 5, photoURLString: photo1URLString) else {
            fatalError("Unable to instantiate music1")
        }
        guard let music2 = Music(name: "Electronic", rating: 3, photoURLString: photo2URLString) else {
            fatalError("Unable to instantiate music2")
        }
        guard let music3 = Music(name: "Earphone", rating: 4, photoURLString: photo3URLString) else {
            fatalError("Unable to instantiate music3")
        }
        guard let music4 = Music(name: "Mark", rating: 3, photoURLString: photo4URLString) else {
            fatalError("Unable to instantiate music4")
        }
        guard let music5 = Music(name: "Colorful", rating: 1, photoURLString: photo5URLString) else {
            fatalError("Unable to instantiate music5")
        }
        guard let music6 = Music(name: "Black", rating: 2, photoURLString: photo6URLString) else {
            fatalError("Unable to instantiate music6")
        }
        guard let music8 = Music(name: "Gif", rating: 2, photoURLString: photo8String) else {
            fatalError("Unable to instantiate music8")
        }
        
        music1.fla_setImageWithURLString(URLString: photo1URLString)
        music2.fla_setImageWithURLString(URLString: photo2URLString)
        music3.fla_setImageWithURLString(URLString: photo3URLString)
        music4.fla_setImageWithURLString(URLString: photo4URLString)
        music5.fla_setImageWithURLString(URLString: photo5URLString)
        music6.fla_setImageWithURLString(URLString: photo6URLString)
        
        //music8.photoURLString = photo8String
//        music8.fla_setImageWithURLString(URLString: photo8String, placeholder: photo8?.posterImage)
        music8.fla_setImageWithURLString(URLString: photo8String)
        
        musics += [music8, music1, music2, music3, music4, music5, music6]
    }
    private func saveMusics(){
        //archivet the musics array to a specific location, returns true if it's successful
        //use Music.ArchiveURL defined in the Music class to identify where to save the information

        //encode Music structure as Data
        let jsonEncoder = JSONEncoder()
        var jsonEncoderData: Data?
//        var jsonEncoderString: String?
        do{
            jsonEncoderData = try jsonEncoder.encode(musics)
//            jsonEncoderString = String(data: jsonEncoderData! as Data, encoding: String.Encoding.utf8)
//            print(jsonEncoderString ?? "JsonEncoderString is empty")
        } catch let error as NSError {
            print("Encoding Json Data Error:\(error.localizedDescription)")
        }
        
        //create Json
//        let musicJsonDict = toJson(musics: musics) as NSDictionary
        var musicJson: Any?
        
        //create json out of the above array
        if let musicData = jsonEncoderData {
            musicJson = try? JSONSerialization.jsonObject(with: musicData, options: .allowFragments)
//            print(musicJson!)
        }
        
        //write json to the file
        let success = FileManager.default.createFile(atPath: Music.ArchiveURL.path, contents: jsonEncoderData!, attributes: nil)
        if success {
            os_log("Musics successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save musics...", log: OSLog.default, type: .error)
        }
        //            let file = FileHandle.init(forWritingAtPath: Music.ArchiveURL.path)
        //let file = try FileHandle(forWritingTo: URL(string: Music.jsonFilePath!)!)
        //          file?.write(musicJson! as! Data)
        //            print("Json data was written to the file successfully! Path is \(String(describing: Music.ArchiveURL.path))")
        
        //local drive save data
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(musicJson!, toFile: Music.ArchiveURL.path)
//        print(Music.ArchiveURL.path)
//
//        //quickly check if data saved successfully, log message to the console
//        if isSuccessfulSave {
//            os_log("Musics successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save musics...", log: OSLog.default, type: .error)
//        }
        
        //Post data to URL Server
        postDataToMockServer(musicJson: musicJson)
    }
    //read data from local
    private func loadMusics() -> [Music]? {
        //return type of an optional array of Music objects, might return an array of Music objects, or nil
        //unarchive the object stored at the path Music.ArchiveURL.path
        //downcast that object to an array of Music objects
        //could return nil if downcast fails, could happens because an array hasnot yet been save
        
        //parse json file to music objects
//        let musicJson = NSKeyedUnarchiver.unarchiveObject(withFile: Music.ArchiveURL.path)
//        if musicJson == nil {return nil}

        //convert Json back to Data
        var musicJsonData: Data?
        var decodedMusics: [Music]?
        
        let file = FileHandle(forReadingAtPath: Music.ArchiveURL.path)
        if(file == nil) {return nil}
        musicJsonData = file?.readDataToEndOfFile()
        
//          musicJsonData = try? JSONSerialization.data(withJSONObject: musicJson, options: JSONSerialization.WritingOptions())
        
        if let musicData = musicJsonData {
            decodedMusics = try! JSONDecoder().decode(Array<Music>.self, from: musicData)
        }
        
        for music in decodedMusics! {
            let isGif = music.photoURLString?.lowercased().hasSuffix("gif")
            if isGif == false{
                music.photoURLString = Bundle.main.path(forResource: "Images/\(music.name)", ofType: "jpeg")
            }
            if(music.photoURLString == nil) {return nil}
            music.fla_setImageWithURLString(URLString: music.photoURLString)
        }

        return decodedMusics
    }
    //transfer Music Object Array to NSDictionary
    private func toJson(musics : [Music])->[String: Any]{
        var musicDict = [String: Any]()
        for music in musics {
            let property = ["name": music.name, "rating": music.rating, "photoURLString": music.photoURLString ?? ""] as [String : Any]
            musicDict[music.name] = property
        }
        //print(musicDict)
        return musicDict
    }
    //Get Data to Mock Server
    private func getDataFromMockServer(completion: @escaping([Music]?)->()){
        //Get data to Mock Server
        //"https://httpbin.org/post"
        //"https://my-json-server.typicode.com/HevaWu/IOS_Practice/songs"
        
        guard let url = URL(string: "http://127.0.0.1:8000/musics/") else {return }
//        var dataJson: Bool = false
        let session = URLSession.shared
        session.dataTask(with: url) {(data: Data? , response: URLResponse?, error: Error?)->Void in
            if let httpResponse = response as? HTTPURLResponse {
                print("responseCode \(httpResponse.statusCode)")
            }
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
                print(json)
                let musicJsonData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
                var decodedMusics: [Music]?
                if let musicData = musicJsonData {
                    decodedMusics = try! JSONDecoder().decode(Array<Music>.self, from: musicData)
                }
                
                if(decodedMusics == nil) {return}
                
                for music in decodedMusics! {
                    let isGif = music.photoURLString?.lowercased().hasSuffix("gif")
                    if isGif == false{
                        music.photoURLString = Bundle.main.path(forResource: "\(music.name)", ofType: "jpeg")
                    }
                    if(music.photoURLString == nil) {continue}
                    music.fla_setImageWithURLString(URLString: music.photoURLString)
                }
                //help achieve the asynchronous
                completion(decodedMusics)
            }
        }.resume()
//        RunLoop.main.run()
    }
    //Make a POST Request and Parsing the response
    private func postDataToMockServer(musicJson: Any?){
        //post single music to the server
        guard let url = URL(string: "http://127.0.0.1:8000/musics/") else {return}
//        let temp:[String:Any?] = ["name": "haha", "rating": 4, "photoURLString": "/hhhh"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: musicJson!, options: .prettyPrinted)
        } catch let error {
            print("Error in HTTP: \(error.localizedDescription)")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(data: Data? , response: URLResponse?, error: Error?)->Void in
            if let httpResponse = response as? HTTPURLResponse {
                print("responseCode \(httpResponse.statusCode)")
            }
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
                print(json)
            }
        }
        task.resume()
    }
    private func checkURLMusics(savedMusics: [Music]){
        if(savedMusics.count==0){
            self.loadSampleMusics()
        } else {
            self.musics += savedMusics
        }
    }
}
