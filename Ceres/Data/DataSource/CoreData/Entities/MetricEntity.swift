//
//  MetricEntity.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation
import CoreData

@objc(MetricEntity)
public class MetricEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var createDate: Date

    @NSManaged public var type: Int16

    @NSManaged public var value: Double

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createDate = Date()
    }
}

extension MetricEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetricEntity> {
        let request = NSFetchRequest<MetricEntity>(entityName: "MetricEntity")
        request.sortDescriptors = []
        return request
    }
}

extension MetricEntity: Identifiable { }
