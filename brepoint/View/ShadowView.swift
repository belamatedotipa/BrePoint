//
//  ShadowView.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/9/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }



}
