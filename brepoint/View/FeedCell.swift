//
//  FeedCell.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/13/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, content: String) {
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.messageLabel.text = content
    }
    
}
