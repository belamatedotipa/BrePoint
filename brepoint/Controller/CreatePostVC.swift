//
//  createPostVC.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/13/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {
    
    var isNotPlaceholdertext: Bool?
    
//Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        
        sendButton.bindToKeyBoard()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userEmailLabel.text = Auth.auth().currentUser?.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageTextView.text != nil && isNotPlaceholdertext! {
            sendButton.isEnabled = false
            DataService.instance.uploadPost(uid: (Auth.auth().currentUser?.uid)!, withMessage: messageTextView.text, withGroupKey: nil) { (success, error) in
                if success {
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: error?.localizedDescription))
                    self.sendButton.isEnabled = true
                }
            }
        }
    
    }
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CreatePostVC : UITextViewDelegate {
   internal func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
        isNotPlaceholdertext = true
    }
}
