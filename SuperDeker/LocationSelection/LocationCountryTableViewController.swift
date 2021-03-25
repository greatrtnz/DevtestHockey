//
//  LocationCountryTableViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/22/21.
//

import UIKit

class LocationCountryTableViewController: UITableViewController {
    
   
    struct Country : Codable {
        let id: String
        let sortname: String
        let name: String
    }
    
    var countries: [Country] = [Country]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        countries = loadJsonCountries(fileName: "countries") ?? [Country]()
        let AllCountries =  Country(id:"0",sortname:"All",name:"All")
                
        countries.insert(AllCountries, at: 0)
        
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
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCountryCell", for: indexPath) as! LocationCountryTableViewCell

        // Configure the cell...
        let Count = countries[indexPath.row]
        cell.CountryName?.text = Count.name
        
        if (Count.name == "All"){
            cell.StatesButton.isHidden = true
        }
        else{
            cell.StatesButton.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(LocationCountryTableViewController.SelectState))
             cell.StatesButton.addGestureRecognizer(tap)
             cell.StatesButton.isUserInteractionEnabled = true
             cell.StatesButton.tag = indexPath.row
        }
        return cell
    }
    
    
    @objc func SelectState(_ sender:AnyObject) {
        activeCell = sender.view.tag
        print("Showing states of " + countries[activeCell].name)
        let defaults = UserDefaults.standard
        defaults.set(countries[activeCell].name, forKey: "CountryQuerySelected")
       //LocationStateTableViewController
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationStateTableViewController") as! UIViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Country List"
    }

   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(countries[indexPath.row])
             let defaults = UserDefaults.standard
        defaults.set(countries[indexPath.row].name, forKey: "CountryQuerySelected")
        defaults.set("", forKey: "StateQuerySelected")
        defaults.set("", forKey: "CityQuerySelected")

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
    
    func loadJsonCountries(fileName: String) -> [Country]? {
        if let asset = NSDataAsset(name: fileName) {
            let data = asset.data
            let decoder = JSONDecoder()
            let countries = try? decoder.decode([Country].self, from: data)
            return countries
        }
       return nil
    }
}




