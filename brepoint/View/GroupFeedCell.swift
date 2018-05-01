//
//  GroupFeedCell.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/25/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureFeedCell(profileImage: UIImage, email: String, message: String)
    {
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = message
        
    }



}
