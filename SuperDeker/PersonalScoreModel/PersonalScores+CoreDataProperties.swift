//
//  PersonalScores+CoreDataProperties.swift
//  SuperDeker
//
//  Created by Luis Bermudez on 3/1/21.
//
//

import Foundation
import CoreData


extension PersonalScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalScores> {
        return NSFetchRequest<PersonalScores>(entityName: "PersonalScores")
    }

    @NSManaged public var when_date: Date?
    @NSManaged public var stick: String?
    @NSManaged public var score: Int16
    @NSManaged public var puck: String?
    @NSManaged public var panels: Int16
    @NSManaged public var nickname: String?
    @NSManaged public var game: String?
    @NSManaged public var dekerbar: Bool
    @NSManaged public var bands: Bool

}

extension PersonalScores : Identifiable {

}
