//
//  RatingControl.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/11.
//  Copyright © 2017 He Wu. All rights reserved.
//

import UIKit

//IBDesignable lets interface builder instantiate and draw a copy of your control directly in the canvas
@IBDesignable class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //Mark: Properties
    //create a property that contains the list of buttons
    private var ratingButtons = [UIButton]()
    var rating = 0{
        didSet{
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width:44.0, height:44.0){
        //update the control, reset the control's buttons every time these attributes change
        //didSet property observer is called immediately after the property's value is set
        //then implementation calls the setupButtons() method. this method adds new buttons using the updated size and count
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setupButtons()
        }
    }
    
    //Mark: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //Mark: Button Action
    @objc func ratingButtonTapped(button: UIButton){
        //use print function to check the ratingButtonTapped() action is linked to the button as expected
        //print the Xcode Debug console
        //print("Button pressed 👍")
        //indexOf() method attempts to find the selected button in the array of buttons and to return the index at which it was found
        //return an optional Int because the instance you're searching might not exist in the collection you're searching
        //if indexof cannot find the button, throw error
        guard let index = ratingButtons.index(of: button) else{
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        //Calculate the rating of the selected button
        let selecteRating = index + 1
        
        if selecteRating == rating{
            //If the selected star represents the current rating, reset the rating to 0
            rating = 0
        } else {
            //Otherwise set the rating to the selected star
            rating = selecteRating
        }
    }
    
    //Mark: Private Methods
    private func setupButtons(){
        //clear any existing buttons
        //tells the stack view that it should no longer calculate the button's size and position
        //the button is still a subview of the stack view
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load Button Images
        //load the star images from the assets catalog
        //because the control is @IBDesignable, the setup code also needs to run in Interface Builder
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        
        //we need five stars, five buttons
        for index in 0..<starCount{
            //Create the button
            let button = UIButton()
            
            //Set the button images
            //buttons have five status: normal, highlighted, forcused, selected, and disabled
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //Add constraints
            //disable the button's automaticaly generated constraints
            //tells the layout engine to create constraints that define the view's size and position based on the view's frame and autoresizingmask properties
            button.translatesAutoresizingMaskIntoConstraints = false
            //create constraints define the button's height and width
            //equalToConstant method return a constraint defines a constant height or width for the view
            //isActive activates or deactivates the constraint, set this property true, system adds the constraint to the correct view, and activates it
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Set the accessibililty label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup the button action
            //attaching the ratingButtonTapped() action method to the button object
            //target: self, refers to the RatingControl object that is etting up the buttons
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //Add the button to the stack
            //this method adds the button you created to the list of views managed by the RatingControl stack view
            //this action adds the view as a subview of the RatingControl, instructs the RatingControl to create the constraints needed to manage the buttons position within the control
            addArrangedSubview(button)
            
            //Add the new button to the rating button array
            
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
        
    }
    private func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerated(){
            //If the index of a button is less than the rating, that button should be selected
            //If the button's index less than rating, isSelected = true, button displays the filled-in star image
            button.isSelected = index < rating
            
            //Set the hint string for the currently selected star
            //check if the button is the currently selected button, if it is, assign a hint, if not, set the hintString to nil
            let hintString: String?
            if rating == index + 1{
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            //Calculate the value string
            //use switch assign the custom string it the rating is 0 or 1
            let valueString: String
            switch(rating){
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

}
