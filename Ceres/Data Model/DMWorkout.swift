//
//  DMWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

enum DMWorkoutType: Int16, CaseIterable {
    case none
    case ft
    case rft
    case amrap
    case emom
    case tabata
    case fgb
    case dbr
}

enum DMWorkoutCategory: Int16, CaseIterable {
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
