//
//  LocationCityTableViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/23/21.
//

import UIKit

class LocationCityTableViewController: UITableViewController {
    
    struct Cities : Codable {
        let id: String
        let name: String
        let state_id: String
    }
    
    var cities: [Cities] = [Cities]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let defaults = UserDefaults.standard
        let filename = (defaults.string(forKey: "CountryQuerySelected") ?? "") + "-" + (defaults.string(forKey: "StateQuerySelected") ?? "") + "-Cities"
        print("filename is:" + filename)
        
         
        cities = loadJsonCities(fileName: filename) ?? [Cities]()
       
        
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
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCityCell", for: indexPath)

        // Configure the cell...
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "City List"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cities[indexPath.row].name)
        let defaults = UserDefaults.standard
        defaults.set(cities[indexPath.row].name, forKey: "CityQuerySelected")
        //self.navigationController?.popViewController(animated: true)
        backThree()
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
    func loadJsonCities(fileName: String) -> [Cities]? {
        if let asset = NSDataAsset(name: fileName) {
            let data = asset.data
            let decoder = JSONDecoder()
            let cities = try? decoder.decode([Cities].self, from: data)
            return cities
        }
       return nil
    }
    
    func backThree() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
}


