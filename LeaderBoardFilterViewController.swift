//
//  LeaderBoardFilterViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/19/21.
//

import UIKit
import CoreData


struct Score: Codable {
    var game : String
    var nickname : String
    var score : String
    var country : String
    var state : String
    var city : String
    var age : String
    var gender : String
    var skill : String
    var puck : String
    var dekerbar : String
    var bands : String
    var panels : String
    var stick : String
    var glove : String
    var videolink : String
    var when_date : String
}

struct LeaderBoardResult: Codable {
    var result: String
    var ret: [Score]
}

class LeaderBoardFilterViewController: UIViewController {
    //MARK: Properties
     
    @IBOutlet weak var GameSelectedButton: UIButton!
    
    @IBOutlet weak var LocationSelectedButton: UIButton!
    
    @IBOutlet weak var SillLevelselectedButton: UIButton!
    
    @IBOutlet weak var AgeBracketSelectedBtutton: UIButton!
    
    @IBOutlet weak var GenderControl: UISegmentedControl!
    
    @IBOutlet weak var PuckControl: UISegmentedControl!
    
    @IBOutlet weak var DekerbarSiwtch: UISwitch!
    
    @IBOutlet weak var BandsSwitch: UISwitch!
    
    @IBOutlet weak var PanelsSlider: UISlider!
    
    @IBOutlet weak var PanelsLabel: UILabel!
    
    @IBOutlet weak var DoneFilter: UIBarButtonItem!
    
    var OptionsToShow = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let defaults = UserDefaults.standard
        self.PanelsLabel.text = " 2 "
        self.PanelsSlider.setValue(2.0, animated: true)
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let defaults = UserDefaults.standard
        let GameQuerySelected = defaults.string(forKey: "GameQuerySelected") ?? "Training"
        
        GameSelectedButton.setTitle(GameQuerySelected + " >", for: .normal)
        
        var LocationSelected = defaults.string(forKey: "CountryQuerySelected") ?? "All"
        
        let StateSelected = defaults.string(forKey: "StateQuerySelected") ?? ""
        if (StateSelected != ""){
            LocationSelected = LocationSelected + "-" + StateSelected
        }
        
        let CitySelected = defaults.string(forKey: "CityQuerySelected") ?? ""
        if (CitySelected != ""){
            LocationSelected = LocationSelected + "-" + CitySelected
        }
        
        LocationSelectedButton.titleLabel!.numberOfLines = 0
        LocationSelectedButton.titleLabel!.adjustsFontSizeToFitWidth = true
        LocationSelectedButton.titleLabel!.minimumScaleFactor = 0.5
        // below line to add some inset for text to look better
        // you can delete or change that
        LocationSelectedButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        LocationSelectedButton.setTitle(LocationSelected + " >", for: .normal)
        
        let SkillQuerySelected = defaults.string(forKey: "SkillLevelQuerySelected") ?? "All"
        
        SillLevelselectedButton.setTitle(SkillQuerySelected + " >", for: .normal)
        
        let AgeBracketQuerySelected = defaults.string(forKey: "AgeBracketQuerySelected") ?? "All"
        
        AgeBracketSelectedBtutton.setTitle(AgeBracketQuerySelected + " >", for: .normal)
        
        //CountryQuerySelected
        
    }
    //MARK Actions
    
    @IBAction func PanelsChanged(_ sender: Any) {
        
        let sliderVal = Int(self.PanelsSlider.value) //?? 1
        
        self.PanelsLabel!.text = " \(sliderVal) "
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(sliderVal, forKey: "PanelsquerySelected")
        
    }
    
    @IBAction func FilterDone(_ sender: Any) {
        let defaults = UserDefaults.standard
        let GameQuerySelected = defaults.string(forKey: "GameQuerySelected") ?? "Training"
        
        self.OptionsToShow = ""
        
        var CountrySelected = defaults.string(forKey: "CountryQuerySelected") ?? "All"
        
        if (CountrySelected == "United States"){
            CountrySelected = "USA"
        }
        
        if (CountrySelected == "All"){
            CountrySelected = "%20"
        }
        
        if (CountrySelected != "%20"){
            self.OptionsToShow = CountrySelected
        }
        
        var StateSelected = defaults.string(forKey: "StateQuerySelected") ?? ""
        if StateSelected == "" {
            StateSelected = "%20"
        }
        
        if (StateSelected != "%20"){
            self.OptionsToShow = CountrySelected + ", " + StateSelected
        }
        
        var CitySelected = defaults.string(forKey: "CityQuerySelected") ?? ""
        if CitySelected == "" {
            CitySelected = "%20"
        }
        if (CitySelected != "%20"){
            self.OptionsToShow = CountrySelected + ", " + StateSelected + ", " + CitySelected
        }
        
        
        var SkillQuerySelected = defaults.string(forKey: "SkillLevelQuerySelected") ?? "All"
        if SkillQuerySelected == "All"{
            SkillQuerySelected = "%20"
        }
        
        if SkillQuerySelected != "%20"{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", skill:" + SkillQuerySelected
            }
            else{
                self.OptionsToShow = "skill:" + SkillQuerySelected
            }
        }
        
        var AgeBracketQuerySelected = defaults.string(forKey: "AgeBracketQuerySelected") ?? "All"
        if AgeBracketQuerySelected != "All"{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", Age:" + AgeBracketQuerySelected
            }
            else {
                self.OptionsToShow = "Age:" + AgeBracketQuerySelected
            }
        }
        switch AgeBracketQuerySelected{
        case "All":
            AgeBracketQuerySelected = "%20"
        case "7 & Under":
            AgeBracketQuerySelected = "0-7"
        case "18 & Over":
            AgeBracketQuerySelected = "18-135"
        default:
            let donothing = true
            //AgeBracketQuerySelected = AgeBracketQuerySelected.replacingOccurrences(of: "-", with: ">" )
        }
        
        
        var GenderSelected = GenderControl.titleForSegment(at: GenderControl.selectedSegmentIndex)
        
        switch GenderSelected {
        case "All":
            GenderSelected = "%20"
        case "Male":
            GenderSelected = "1"
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", gender:" + "Male"
            }
            else{
                self.OptionsToShow = "gender:" + "Male"
            }
        case "Female":
            GenderSelected = "0"
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", gender:" + "Female"
            }
            else{
                self.OptionsToShow = "gender:" + "Female"
            }
        default:
            GenderSelected = "%20"
        }
        
        var PuckSelected = PuckControl.titleForSegment(at: PuckControl.selectedSegmentIndex)
        
        if self.OptionsToShow != "" {
            self.OptionsToShow = self.OptionsToShow + ", " + PuckSelected!
        }
        else{
            self.OptionsToShow = PuckSelected!
        }
        
        switch PuckSelected {
            case "ePuck":
                PuckSelected = "e"
            case "ePuck-Max":
                PuckSelected = "max"
            case "eBall":
                PuckSelected = "ball"
            default:
                PuckSelected = "e"
        }
        
        let BandsSelected = BandsSwitch.isOn ? "1" : "0"
        
        if BandsSwitch.isOn{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", Bands"
            }
            else{
                self.OptionsToShow = "Bands"
            }
        }
        else{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", No Bands"
            }
            else{
                self.OptionsToShow = "No Bands"
            }
        }
        
        let DekerbarSelected = DekerbarSiwtch.isOn ? "1" : "0"
        
        if DekerbarSiwtch.isOn{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", Dekerbar"
            }
            else{
                self.OptionsToShow = "Dekerbar"
            }
        }
        else{
            if self.OptionsToShow != "" {
                self.OptionsToShow = self.OptionsToShow + ", No Dekerbar"
            }
            else{
                self.OptionsToShow = "No Dekerbar"
            }
        }

        print ("Game selected is " + GameQuerySelected)
        print ("Country selected is " + CountrySelected)
        print ("State selected is " + StateSelected)
        print ("City selected is " + CitySelected)
        print ("Skill selected is " + SkillQuerySelected)
        print ("AgeBracket selected is " + AgeBracketQuerySelected)
        print ("Gender selected is " + GenderSelected!)
        print ("Puck selected is " + PuckSelected!)
        print ("Band  is " + BandsSelected)
        print ("DekerBar  is " + DekerbarSelected)
        
        FilterLeaderBoard(Game: GameQuerySelected, Country: CountrySelected, State: StateSelected, City: CitySelected, Skill: SkillQuerySelected, AgeBracket: AgeBracketQuerySelected, Gender: GenderSelected!, Puck: PuckSelected!, Band: BandsSelected, Dekerbar: DekerbarSelected, Panels: "2")
        
        
    }
    
    func FilterLeaderBoard(Game : String, Country: String, State : String, City : String, Skill : String, AgeBracket : String, Gender : String, Puck : String, Band : String, Dekerbar : String, Panels: String){
        DoneFilter.isEnabled=false
        
        let spin = SpinnerViewController()
        // add the spinner view controller
        showSpin(vspin:spin)
       
        var urlString = "https://dossierplus-srv.com/superdeker/api/QueryScores.php/" + Game.replacingOccurrences(of: " ", with: "-")
        urlString += "/" + Country
        urlString += "/" + State
        urlString += "/" + City
        urlString += "/" + AgeBracket
        urlString += "/" + Gender
        urlString += "/" + Skill
        urlString += "/" + Puck
        urlString += "/" + Dekerbar
        urlString += "/" + Band
        urlString += "/" + Panels
        
        print(urlString)
        
        let url = URL(string: urlString )
                        
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.hideSpin(vspin: spin)
            
            if let error = error {
                print("Error took place \(error)")
                self.DoneFilter.isEnabled=true
                return
            }
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print (dataString)
                let LeaderBoardResult = self.parseRegRet(data: data)
                if (LeaderBoardResult?.result != "Ok"){
                    //self.PopAlert(mess: RegModelRet?.err ?? "Regiter error, please try again!")
                    
                    
                    self.PopAlert(mess: "No Scores found with selected filter!")
                    self.DoneFilter.isEnabled=true
                   
                    return
                }
                else{
                    if ( LeaderBoardResult?.result == "Ok"){
                        
                        DispatchQueue.main.async {
                            //let defaults = UserDefaults.standard
                            //no more showing Welcome String because
                            //defaults.set(false, forKey: "FirstRun" you have been athorized
                            //self.PopAlert(mess: "Looks Good")
                            //self.JumpToMain()
                            self.DoneFilter.isEnabled=true
                            let count = (LeaderBoardResult?.ret.count)! - 1
                            self.deleteLeaderBoardScores()
                            let defaults = UserDefaults.standard
                            defaults.set(Game, forKey: "GameShown")
                            defaults.set(self.OptionsToShow, forKey: "OptionsShown")
                            let context = (UIApplication .shared.delegate as! AppDelegate).persistentContainer.viewContext
                            for xx in 0...count {
                                let Score = LeaderBoardScore(context: context)
                                Score.game = LeaderBoardResult?.ret[xx].game
                                Score.nickname = LeaderBoardResult?.ret[xx].nickname
                                Score.score = Int16((LeaderBoardResult?.ret[xx].score)!) ?? 0
                                Score.country = LeaderBoardResult?.ret[xx].country
                                Score.state = LeaderBoardResult?.ret[xx].state
                                Score.city = LeaderBoardResult?.ret[xx].city
                                Score.age = Int16((LeaderBoardResult?.ret[xx].age)!) ?? 0
                                Score.gender = (LeaderBoardResult?.ret[xx].gender=="1")
                                Score.skill = LeaderBoardResult?.ret[xx].skill
                                Score.puck = LeaderBoardResult?.ret[xx].puck
                                Score.dekerbar = (LeaderBoardResult?.ret[xx].dekerbar == "1")
                                Score.bands = (LeaderBoardResult?.ret[xx].bands == "1")
                                //Dejaremos los panels, gloves y stickes para despues, porque no se necesitan
                                Score.videolink = LeaderBoardResult?.ret[xx].videolink
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                Score.when_date = dateFormatter.date(from:(LeaderBoardResult?.ret[xx].when_date)!)!
                                do {
                                    try context.save()
                                }
                                catch {
                                }
                            }
                            //return
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func showSpin(vspin: SpinnerViewController){
        addChild(vspin)
        vspin.view.frame = view.frame
        view.addSubview(vspin.view)
        vspin.didMove(toParent: self)
    }
    
    func hideSpin(vspin: SpinnerViewController){
        DispatchQueue.main.async {
            vspin.willMove(toParent: nil)
            vspin.view.removeFromSuperview()
            vspin.removeFromParent()// Check if Error took place
        }
    }
    
    func parseRegRet(data: Data) -> LeaderBoardResult? {
        
        var returnValue: LeaderBoardResult?
        do {
            returnValue = try JSONDecoder().decode(LeaderBoardResult.self, from: data)
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        return returnValue
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
    
    func deleteLeaderBoardScores(){
        let context = (UIApplication .shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LeaderBoardScore")
        
        fetchRequest.includesPropertyValues = false

        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]

            for item in items {
                context.delete(item)
            }

            // Save Changes
            try context.save()

        } catch {
            // Error Handling
            // ...
        }
    }

    
}

