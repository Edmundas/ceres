//
//  MovementDefinitionEntity.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation
import CoreData

@objc(MovementDefinitionEntity)
public class MovementDefinitionEntity: NSManagedObject {
    @NSManaged public var id: UUID

    @NSManaged public var title: String

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

extension MovementDefinitionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovementDefinitionEntity> {
        let request = NSFetchRequest<MovementDefinitionEntity>(entityName: "MovementDefinitionEntity")
        request.sortDescriptors = []
        return request
    }
}

extension MovementDefinitionEntity: Identifiable { }
