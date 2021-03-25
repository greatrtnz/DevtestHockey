//
//  AlertCenterViewController.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 1/5/21.
//

import UIKit
import CoreData
import Foundation
import Charts


class ScoreCell{
    var Position : String = ""
    var Nickname : String = ""
    var Country : String = ""
    var Skill : String = ""
    var Age: String = ""
    var Gender: String = ""
    var Score: String = ""
}

var activeScoreCell : Int = 0


class LeaderBoardViewController: UIViewController, UITableViewDataSource, ChartViewDelegate {
    @IBOutlet weak var LeaderBoardTableView: UITableView!
    
    @IBOutlet weak var LeaderBoardGameLable: UILabel!
    
    @IBOutlet weak var PositioningLabel: UILabel!
    
    @IBOutlet weak var LeaderBoardOptionsLabel: UILabel!
    
    @IBOutlet weak var SegmentedTimeControl: UISegmentedControl!
    
    var LeaderScores : [LeaderBoardScore]?
    
    var Scores : [ScoreCell] = []
    
    var MyScores : [PersonalScores]?
    
    
    //reference to managed object context
    let context = (UIApplication .shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Score count: \(Scores.count)")
        //return AlertNotifs.count
        return LeaderScores!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("asking for cell at  \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardCell", for: indexPath) as! LeaderBoardTableViewCell
        let cellAtRow = LeaderScores?[indexPath.row] //Scores[indexPath.row]
        print("Show: \(indexPath.row),  \(cellAtRow!.country) , \(cellAtRow!.nickname),  \(cellAtRow!.score) ")
        
        print ("cellAtRow: \(indexPath.row)")
        
        cell.Position.text = "\(indexPath.row+1)"//cellAtRow.Position
        cell.Nickname.text = cellAtRow!.nickname
        cell.Score.text = "\(cellAtRow!.score)"
        cell.Skill.text = cellAtRow!.skill
        cell.Age.text = " \(cellAtRow!.age) "
        cell.Gender.text = (cellAtRow!.gender) ? " Male" : " Female"
       
        if (cell.CountryFlag == nil){
            print ("country nil")
        }
        
        switch cellAtRow!.country {
            case  "USA":
                cell.CountryFlag!.image = UIImage(named: "FlagUSA")
            case "Canada":
                    cell.CountryFlag!.image = UIImage(named: "FlagCan")
            case "Venezuela":
                 cell.CountryFlag!.image = UIImage(named: "FlagVen")
            case "India":
                 cell.CountryFlag!.image = UIImage(named: "FlagIndia")
            case "Bulgaria":
                 cell.CountryFlag!.image = UIImage(named: "FlagBulgaria")
            default:
                 cell.CountryFlag = nil
            }
        return cell
    }
    
    @objc func someButtonAction(_ sender:AnyObject) {
        print("Video Button is tapped")
    }
    
    
   /* @objc func updateMessages(notification: NSNotification) {
     print("updating and reloading Notifs")
        print("NOTIFICATION")
        print(notification)
        guard let aps = notification.userInfo?["aps"] as? [String : AnyObject] else {
            return
        }
        addNotifAlerts(aps:aps)
        
         //print(aps?["body"])
   }
    */
    
    
    
    @IBOutlet weak var ChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FillScores()
        LeaderBoardTableView.dataSource = self
        
        
        //NotificationCenter.default.addObserver(self,
        //                                       selector: #selector(updateMessages),
        //                                       name: Notification.Name("reload"),
        //                                       object: nil)
        //UIApplication.shared.applicationIconBadgeNumber = 0
        
        fillPersonalScores() // random data till deliverable 5 or 6
        configChartView()
        
        setChartData()
        
    }
    
    func configChartView(){
        ChartView.rightAxis.enabled = false
        let yAxis = ChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        ChartView.xAxis.labelPosition = .bottom
        ChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        ChartView.xAxis.setLabelCount(6, force: false)
        ChartView.xAxis.labelTextColor = .black
        ChartView.xAxis.axisLineColor = .systemBlue
        ChartView.animate(xAxisDuration: 0.5)
        let legend = ChartView.legend
        legend.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)!
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
       // NotificationCenter.default.removeObserver(self, name: Notification.Name("reload"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchNotifsAlerts()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         navigationController?.navigationBar.shadowImage = UIImage()
         navigationController?.navigationBar.isTranslucent = true
        let defaults = UserDefaults.standard
        
        //GameShown
        LeaderBoardGameLable.text = defaults.string(forKey: "GameShown") ?? "Training"
        
        LeaderBoardOptionsLabel.text = defaults.string(forKey: "OptionsShown") ?? ""
        fetchNLeaderScores()
        
        let selectedGame = defaults.string(forKey: "GameShown") ?? "Training"
        var dummy: String = ""
        dummy = selectedGame
        
        
        let modifiedSelectedGame =  dummy.replacingOccurrences(of: " ", with: "_")
        
        DrawPersonalChartTime(CurrentGame : modifiedSelectedGame, DateRange: SegmentedTimeControl.selectedSegmentIndex)
    }
    

   
    
 /*   func fetchPersonalScores(){
        do{
            self.AllNotifs = try context.fetch(PersonalScores.fetchRequest())
            
            DispatchQueue.main.async {
                self.AlertNotifTableView.reloadData()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        catch {
            
        }
        
    }*/
    
    
    
    func fetchNLeaderScores(){
        do{
            //self.LeaderScores = []
            switch self.SegmentedTimeControl.selectedSegmentIndex{
            case 0: // All Time
                var SelectedRangeDate = Date()
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -7200, to: SelectedRangeDate)!
               
                let predicate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "LeaderBoardScore")
                fetchRequest.predicate = predicate
                self.LeaderScores = try (context.fetch(fetchRequest) as? [LeaderBoardScore])
              
            
            case 1: // Year
                var SelectedRangeDate = Date()
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -365, to: SelectedRangeDate)!
               
                let predicate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "LeaderBoardScore")
                fetchRequest.predicate = predicate
                self.LeaderScores = try (context.fetch(fetchRequest) as? [LeaderBoardScore])
              
            
            case 2: // Month
                var SelectedRangeDate = Date()
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -30, to: SelectedRangeDate)!
               
                let predicate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "LeaderBoardScore")
                fetchRequest.predicate = predicate
                self.LeaderScores = try (context.fetch(fetchRequest) as? [LeaderBoardScore])
              
            
            case 3: // Week
                var SelectedRangeDate = Date()
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -7, to: SelectedRangeDate)!
               
                let predicate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LeaderBoardScore")
                fetchRequest.predicate = predicate
                self.LeaderScores = try (context.fetch(fetchRequest) as? [LeaderBoardScore])
              
            
            default:
                var SelectedRangeDate = Date()
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -7200, to: SelectedRangeDate)!
               
                let predicate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "LeaderBoardScore")
                fetchRequest.predicate = predicate
                self.LeaderScores = try (context.fetch(fetchRequest) as? [LeaderBoardScore])
              
              
            }
            let defaults = UserDefaults.standard
            let nickname = defaults.string(forKey: "ActiveUser")
            if self.LeaderScores!.count > 0 {
                for xx in 0...(self.LeaderScores!.count-1){
                    if self.LeaderScores![xx].nickname == nickname { // found my self on
                        self.PositioningLabel.text = String(xx + 1) + "/" + String(self.LeaderScores!.count) + " (" + String(self.LeaderScores![xx].score) + ")"
                        break
                    }
                    self.PositioningLabel.text = "N/A"
                }
            }
            else{
                self.PositioningLabel.text = "N/A"
            }
             //fetchRequest.sortDescriptors = [] //optionally you can specify the order in which entities should ordered after fetch finishes
           DispatchQueue.main.async {
                self.LeaderBoardTableView.reloadData()
            }
        }
        catch {
            
        }
        
    }
    
    struct GamePlayed{
        var datePlayed : Date
        var score : Int
    }
    
    
    //var PersonalScores: [GamePlayed] = []
    
    var yValues: [ChartDataEntry] = []
    
    func fillPersonalScores(){
        deletePersonalScores()
        let defaults = UserDefaults.standard
        
        let selectedGame = defaults.string(forKey: "GameShown") ?? "Training"
        
        var dummy = ""
        
        dummy = selectedGame
        
        let ModifiedSelectedGame = dummy.replacingOccurrences(of: " ", with: "_")
        
        
        let posibleGames = ["Training", "Hot_Shot","Multiplier","Infinity_Dangles","Around_the_World"]
        let puckValues = ["e","max","ball"]
        for xx in 0...400 {
            let Score = PersonalScores(context: context)
            Score.game = posibleGames[Int.random(in: 0...4)]
            Score.nickname = defaults.string(forKey: "ActiveUser")
            let dummy = xx % 100
            Score.score = Int16(Int.random(in: (33+(dummy)..<155)))
            Score.puck = puckValues[Int.random(in:0...2)]
            Score.dekerbar = Int.random(in: 0...1) == 0
            Score.bands = Int.random(in: 0...1) == 0
            //Dejaremos los panels, gloves y stickes para despues, porque no se necesitan
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            Score.when_date = Calendar.current.date(byAdding: .day, value: -100 + (xx % 100), to: date)
            do {
                try context.save()
            }
            catch {
            }
        }
        
        //let managedObjectContext: NSManagedObjectContext
        let predicate = NSPredicate(format: "game == %@", ModifiedSelectedGame)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "PersonalScores")
        fetchRequest.predicate = predicate
        //fetchRequest.sortDescriptors = [] //optionally you can specify the order in which entities should ordered after fetch finishes

        do {
            var results = [PersonalScores]()
            results = try context.fetch(fetchRequest) as! [PersonalScores]
            let count = results.count
            yValues = []
            if count > 0 {
                for xx in 1..<count{
                   
                  /* var game = GamePlayed(datePlayed: Date(), score : Int.random(in: (33+xx)..<155))
                   
                   game.datePlayed = Calendar.current.date(byAdding: .day, value: -100 + xx, to: game.datePlayed)!
                   PersonalScores.append(game)*/
                   
                   let dummy = ChartDataEntry()
                   
                   dummy.x = Double(xx)
                   
                    
                    
                    dummy.y =  Double(results[xx].score)
                  
                   yValues.append(dummy)
                   
                }
            }
        }
        catch {
        }
        
            
     
        
    }
    
    func setChartData(){
        let defaults = UserDefaults.standard
        
        let SelectedGame = defaults.string(forKey: "GameShown") ?? "Training"
        let timeRange =  self.SegmentedTimeControl.titleForSegment(at: self.SegmentedTimeControl.selectedSegmentIndex)!
        let set1 = LineChartDataSet(entries: yValues, label: "Personal " + timeRange + "  Scores for " + SelectedGame)
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fillColor = UIColor.white
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.6
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        
        data.setDrawValues(false)
        
        ChartView.data = data
        
       
        
        //ChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:14)!
        
    }
    
    
    func deletePersonalScores(){
        let context = (UIApplication .shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersonalScores")
        
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

    
    
    func DrawPersonalChartTime(CurrentGame : String, DateRange: Int){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "PersonalScores")
        let predicate = NSPredicate(format: "game == %@", CurrentGame)
        var SelectedRangeDate = Date()
        var numdays = 0;
        switch DateRange{
        case 0: // All Time
            numdays = 500
        case 1: // Year
            numdays = 365
        case 2: // Month
            numdays = 30
        case 3: // Week
            numdays = 7
        default:
            numdays = 500
        }
        SelectedRangeDate = Calendar.current.date(byAdding: .day, value: -numdays, to: SelectedRangeDate)!
        let predicateDate = NSPredicate(format: "when_date > %@", SelectedRangeDate as NSDate)

        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateDate])
        
        fetchRequest.predicate = compound
        //fetchRequest.sortDescriptors = [] //optionally you can specify the order in which entities should ordered after fetch finishes

        do {
            var results = [PersonalScores]()
            results = try context.fetch(fetchRequest) as! [PersonalScores]
            var resultindex = 0
            yValues = []
            if DateRange == 0{
                SelectedRangeDate = results[0].when_date!
                numdays = results.count-1
            }
            for day in 1...numdays{
                if resultindex > results.count-1{
                    break
                }
                let dummy = ChartDataEntry()
                dummy.x = Double(day)
                 
                if Calendar.current.isDate(results[resultindex].when_date!, inSameDayAs:SelectedRangeDate){
                    dummy.y =  Double(results[resultindex].score)
                    resultindex += 1
                }
                else{
                    dummy.y =  Double(0)
                }
                yValues.append(dummy)
                SelectedRangeDate = Calendar.current.date(byAdding: .day, value: 1, to: SelectedRangeDate)!
                
            }
            
            
           /* let count = results.count
            yValues = []
            if count > 0 {
                for xx in 1..<count{
                  /* var game = GamePlayed(datePlayed: Date(), score : Int.random(in: (33+xx)..<155))
                   game.datePlayed = Calendar.current.date(byAdding: .day, value: -100 + xx, to: game.datePlayed)!
                   PersonalScores.append(game)*/
                   let dummy = ChartDataEntry()
                   dummy.x = Double(xx)
                    dummy.y =  Double(results[xx].score)
                   yValues.append(dummy)
                   
                }
            }*/
        }
        catch {
        }
        setChartData()
        configChartView()
    }
    
    @IBAction func TimeRangeSelected(_ sender: Any) {
        print ("Segment " + self.SegmentedTimeControl.titleForSegment(at: self.SegmentedTimeControl.selectedSegmentIndex)! + " selected")
        fetchNLeaderScores()
        let defaults = UserDefaults.standard
        let selectedGame = defaults.string(forKey: "GameShown") ?? "Training"
        var dummy: String = ""
        dummy = selectedGame
        let modifiedSelectedGame =  dummy.replacingOccurrences(of: " ", with: "_")
        DrawPersonalChartTime(CurrentGame : modifiedSelectedGame, DateRange: SegmentedTimeControl.selectedSegmentIndex)
    }
    
    //Mark: outlets
    
 
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
