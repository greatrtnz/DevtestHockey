//
//  SkillLevelTableViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/19/21.
//

import UIKit

class SkillLevelTableViewController: UITableViewController {
    
    var SkillList: [String] = ["All", "AAA","AA", "A" , "B", "C", "D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

       self.navigationController?.navigationBar.isTranslucent = false
       self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
     
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SkillList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillLevelCell", for: indexPath)

        // Configure the cell...
        let skill = SkillList[indexPath.row]
        cell.textLabel?.text = skill
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Skill Levels"
    }

   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(SkillList[indexPath.row])
             let defaults = UserDefaults.standard
            defaults.set(SkillList[indexPath.row], forKey: "SkillLevelQuerySelected")
            self.navigationController?.popViewController(animated: true)
        
    }
    
    func PopAlert(mess: String){
        DispatchQueue.main.async {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            
            nextViewController.modalPresentationStyle = .popover
            nextViewController.modalTransitionStyle = .coverVertical
            self.present(nextViewController, animated: true, completion: nil)
            nextViewController.MessageLabel?.text=mess
            
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}


