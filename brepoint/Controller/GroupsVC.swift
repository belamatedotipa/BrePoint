//
//  SecondViewController.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/6/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    var groupsArray = [Group]()
    
    
    @IBOutlet weak var groupsTableView: UITableView!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.REF_GROUPS.observe(.value) { (returnedSnapshot) in
        DataService.instance.getAllGroups { (returnedGroups) in
            self.groupsArray = returnedGroups
            self.groupsTableView.reloadData()
        }
    }
    }


}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else { return UITableViewCell()}
        let group = groupsArray[indexPath.row]
    cell.configureCell(title: group.groupTitle, description: group.groupDesc, memberCount: group.memberCount)
    return cell
    
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else {return}        
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        presentDetail(groupFeedVC)
    }
    
    
    

    
}

