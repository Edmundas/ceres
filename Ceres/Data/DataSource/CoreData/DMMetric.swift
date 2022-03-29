//
//  DMMetric.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation
import CoreData

enum DMMetricType: Int16, CaseIterable {
    case none
    case weight
    case height
    case distance
    case time
    case reps
}

enum DMMetricSubtype: Int16, CaseIterable {
    case none
    case perRound
    case totalPerRounds
    case minPerRounds
    case maxPerRounds
}

enum DMMetricUnit: Int16, CaseIterable {
    case none
    case rep
    case second
    case centimeter
    case meter
    case kilometer
    case inch
    case feet
    case yard
    case mile
    case kilogram
    case pound
}

@objc(DMMetric)
public class DMMetric: NSManagedObject {
    @NSManaged public var id: UUID
    
    @NSManaged public var type: Int16
    @NSManaged public var subtype: Int16
    @NSManaged public var unit: Int16
    
    @NSManaged public var value: Double
    
    @NSManaged public var workout: DMWorkout?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

extension DMMetric {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DMMetric> {
        let request = NSFetchRequest<DMMetric>(entityName: "DMMetric")
        request.sortDescriptors = []
        return request
    }
}

extension DMMetric: Identifiable { }
