//
//  MusicViewController.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/11.
//  Copyright © 2017 He Wu. All rights reserved.
//

//imports the unified logging system, could send messages to console
import os.log
import UIKit
import FLAnimatedImage

class MusicViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Mark properties
    @IBOutlet weak var nameTextField: UITextField!
   // @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var photoImageView: FLAnimatedImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //This value is either passed by 'MusicTableViewController' in 'prepare(for:sender)' or constructed as part of adding a new music
    //this is an optional music, it may be nil
    var music: Music?
    var photoURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Handle the text fields' user input through delegate callbacks
        nameTextField.delegate = self
        
        //Set up views if editing an existing Music
        if let music = music {
            navigationItem.title = music.name
            nameTextField.text = music.name
            ratingControl.rating = music.rating
            if music.isGif {
//                let photoURLString = music.photoURLString
//                let photoURL =  URL(string: photoURLString)
//                let photoData = NSData(contentsOf: photoURL!)
//                let photoImage = FLAnimatedImage(gifData: photoData! as Data)
//                photoImageView.animatedImage = photoImage
                photoImageView.animatedImage = music.animatedImage
            } else {
                photoImageView.image = music.photo
            }
            photoURL = music.photoURLString
        }
        
        //Enable the Save button only if the text field has a valid Music name
        updateSaveButtonState()
    }
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //musicNameLabel.text = textField.text
        //check if the text field has text in it, enable the save button if it does
        updateSaveButtonState()
        //set the title of the scene
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing
        //this method gets called when an editing session begins, or when the keyboard gets displayed
        //this code disables the save button while the user is editing the text field
        saveButton.isEnabled = false
    }
    
    //Mark: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //The info dictionary may contain multiple representations of the image
        //use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        //create boolean which indicates whether the view controller that presented this scene is of type UINavigationController
        //isPresentingInAddMusicMode indicates music detail scene is presented by the user tapping the Add button
        let isPresentingInAddMusicMode = presentingViewController is UINavigationController
        
        //before called the dismiss() when user tapped the cancle
        //dismiss only work when the user is adding a new meal
        //check to make sure user was adding a new music before calling dismiss
        if isPresentingInAddMusicMode {
            //dismisses the modal scene and animates the transition back to the previous scene
            //does not store any data when music detail scene is dismissed, and neither the prepare() method nor the unwind action method called
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            //if user editing an existing music
            //use if let to safely unwrap the view controller
            //popViewController() pops the current view controller off the navigation stack and animates the transition
            owningNavigationController.popViewController(animated: true)
        } else {
            //if the music detail scene was not presented inside a modal navigation controller
            //if the music detail scene was not pushed onto a navigation stack
            fatalError("The MusicViewController is not inside a navigation controller.")
        }
    }
    //This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //always call super.prepare(for:sender:) whenever you override prepare(for:sender:). That way you won’t forget it when you subclass a different class.
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed
        //verify sender is a button, use (===) check objects referenced by the sender and the saveButton are the same
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type:.debug)
            return
        }
        
        //nil coalescing operator(??) used to return the value of an optional if the optional has a value, or return a default value
        //if nameTextField.text has value, return value, if nil, return ""
        let name = nameTextField.text ?? ""
        //let photo = photoImageView.image
        let animatedImage = photoImageView.animatedImage
        let rating = ratingControl.rating
        
        //Set the music to be passed to MusicTableViewController after the unwind segue
       // music = Music(name: name, photo: photo, rating: rating)
        music = Music(name: name, rating: rating, photoURLString: photoURL)
        music?.animatedImage = animatedImage
        music?.photo = photoImageView.image
        if music?.animatedImage != nil {
            music!.isGif = true            
        } else {
            music!.isGif = false
        }
    }
    
    //Mark Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /*@IBAction func setDefaultLabelTest(_ sender: UIButton) {
        musicNameLabel.text = "Default Text"
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark: Private Methods
    private func updateSaveButtonState(){
        //Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

