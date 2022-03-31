//
//  MovementEntity.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import CoreData

@objc(MovementEntity)
public class MovementEntity: NSManagedObject {
    @NSManaged public var id: UUID

    @NSManaged public var orderNumber: Int16

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

extension MovementEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovementEntity> {
        let request = NSFetchRequest<MovementEntity>(entityName: "MovementEntity")
        request.sortDescriptors = []
        return request
    }
}

extension MovementEntity: Identifiable { }
