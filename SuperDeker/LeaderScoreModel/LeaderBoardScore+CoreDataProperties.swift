//
//  LeaderBoardScore+CoreDataProperties.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 2/25/21.
//
//

import Foundation
import CoreData


extension LeaderBoardScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeaderBoardScore> {
        return NSFetchRequest<LeaderBoardScore>(entityName: "LeaderBoardScore")
    }

    @NSManaged public var game: String?
    @NSManaged public var nickname: String?
    @NSManaged public var score: Int16
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var city: String?
    @NSManaged public var age: Int16
    @NSManaged public var gender: Bool
    @NSManaged public var skill: String?
    @NSManaged public var puck: String?
    @NSManaged public var dekerbar: Bool
    @NSManaged public var bands: Bool
    @NSManaged public var panels: Int16
    @NSManaged public var stick: String?
    @NSManaged public var glove: String?
    @NSManaged public var videolink: String?
    @NSManaged public var when_date: Date?

}

extension LeaderBoardScore : Identifiable {

}
