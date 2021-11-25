//
//  DMWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

enum DMWorkoutType: Int16 {
    case unknown
    case FT
    case RFT
    case AMRAP
    case EMOM
    case TABATA
    case FGB
    case DBR
}

enum DMWorkoutCategory: Int16 {
    case none
    case girl
    case hero
}

@objc(DMWorkout)
public class DMWorkout: NSManagedObject {
    @NSManaged public var id: UUID
    
    @NSManaged public var type: Int16
    @NSManaged public var category: Int16
    
    @NSManaged public var title: String?
    
//    @NSManaged public var rounds: Set<DMRound>?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

extension DMWorkout {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DMWorkout> {
        let request = NSFetchRequest<DMWorkout>(entityName: "DMWorkout")
        request.sortDescriptors = []
        return request
    }
}

extension DMWorkout: Identifiable { }
