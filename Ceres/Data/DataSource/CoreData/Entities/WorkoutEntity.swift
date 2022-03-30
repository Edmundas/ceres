//
//  WorkoutEntity.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

@objc(WorkoutEntity)
public class WorkoutEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var createDate: Date

    @NSManaged public var type: Int16
    @NSManaged public var category: Int16

    @NSManaged public var title: String

    @NSManaged public var metrics: Set<MetricEntity>?
//    @NSManaged public var rounds: Set<RoundEntity>?

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createDate = Date()
    }
}

extension WorkoutEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        request.sortDescriptors = []
        return request
    }
}

extension WorkoutEntity: Identifiable { }
