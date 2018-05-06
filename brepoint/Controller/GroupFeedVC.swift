//
//  GroupFeedVC.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/25/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var composeMessageView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    
    @IBOutlet weak var sendButton: UIButton!
    var group : Group?
    var groupMessages = [Message]()
    
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeMessageView.bindToKeyBoard()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        groupTitleLabel.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.memberLabel.text = returnedEmails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapShot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, completion: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: (self.groupMessages.count - 1), section: 0), at: .none, animated: true)
                }
            })
        }
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
           
            DataService.instance.uploadPost(uid: (Auth.auth().currentUser?.uid)!, withMessage: messageTextField.text!, withGroupKey: group?.key) { (success) in
                self.messageTextField.text = ""
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        DataService.instance.getUserName(forUID: message.senderId) { (email) in
            cell.configureFeedCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, message: message.content)
        }
        return cell
    }
    
}
