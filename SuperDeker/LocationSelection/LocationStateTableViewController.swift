//
//  LocationStateTableViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/22/21.
//

import UIKit

class LocationStateTableViewController: UITableViewController {
    
    struct States : Codable {
        let id: String
        let name: String
        let country_id: String
    }
    
    var states: [States] = [States]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let defaults = UserDefaults.standard
        let filename = (defaults.string(forKey: "CountryQuerySelected") ?? "") + "-States"
        print("filename is:" + filename)
        
        states = loadJsonStates(fileName: filename) ?? [States]()
        
        
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
        return states.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationStateCell", for: indexPath) as! LocationStateTableViewCell

        // Configure the cell...
        let St = states[indexPath.row]
        cell.StateName?.text = St.name
        let tap = UITapGestureRecognizer(target: self, action: #selector(LocationStateTableViewController.SelectCities))
         cell.CitiesButton.addGestureRecognizer(tap)
         cell.CitiesButton.isUserInteractionEnabled = true
         cell.CitiesButton.tag = indexPath.row
    
        return cell
    }
    
    
    @objc func SelectCities(_ sender:AnyObject) {
        activeCell = sender.view.tag
        print("Showing cities of " + states[activeCell].name)
        let defaults = UserDefaults.standard
        defaults.set(states[activeCell].name, forKey: "StateQuerySelected")
       //LocationStateTableViewController
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationCityTableViewController") as! LocationCityTableViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "State List"
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(states[indexPath.row].name)
             let defaults = UserDefaults.standard
        defaults.set(states[indexPath.row].name, forKey: "StateQuerySelected")
        defaults.set("", forKey: "CityQuerySelected")

        //self.navigationController?.popViewController(animated: true)
        backTwo()
        
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
    
    func loadJsonStates(fileName: String) -> [States]? {
        if let asset = NSDataAsset(name: fileName) {
            let data = asset.data
            let decoder = JSONDecoder()
            let states = try? decoder.decode([States].self, from: data)
            return states
        }
       return nil
    }
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}

