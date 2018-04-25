//
//  UserCell.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/17/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var showing = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.emailLabel.text = email
        if isSelected {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImage.isHidden = false
                showing = true
            } else {
            checkImage.isHidden = true
            showing = false
        }
        // Configure the view for the selected state
    }
    }
    
    
    

}
