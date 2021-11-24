//
//  DMWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

@objc(DMWorkout)
public class DMWorkout: NSManagedObject {
    @NSManaged public var id: UUID
    
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
