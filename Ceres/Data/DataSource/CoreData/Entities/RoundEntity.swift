//
//  RoundEntity.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import CoreData

@objc(RoundEntity)
public class RoundEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var createDate: Date

    @NSManaged public var orderNumber: Int16

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createDate = Date()
    }
}

extension RoundEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoundEntity> {
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        request.sortDescriptors = []
        return request
    }
}

extension RoundEntity: Identifiable { }
