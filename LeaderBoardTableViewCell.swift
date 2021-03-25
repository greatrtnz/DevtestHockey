//
//  AlertCenterTableViewCell.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 1/5/21.
//

import UIKit

class LeaderBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Position: UILabel!
    @IBOutlet weak var Nickname: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var Skill: UILabel!
    @IBOutlet weak var Age: UILabel!
    @IBOutlet weak var Gender: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
           // configureView()
        

        }
   
}
