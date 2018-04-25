//
//  Message.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/13/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import Foundation

class Message {
    private var _content: String
    private var _senderId: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
   
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
    

    
    
    
}
