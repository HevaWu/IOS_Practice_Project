//
//  MusicTableViewCell.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/12.
//  Copyright © 2017 He Wu. All rights reserved.
//

import UIKit
import FLAnimatedImage

class MusicTableViewCell: UITableViewCell {
    //Mark: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: FLAnimatedImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
