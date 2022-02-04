//
//  DataManager+Metric.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation
import CoreData

protocol MetricDataManagerProtocol {
    func createMetric(value: Double, type: DMMetricType, subtype: DMMetricSubtype, unit: DMMetricUnit) -> DMMetric
}

// MARK: - WorkoutDataManagerProtocol
extension DataManager: MetricDataManagerProtocol {
    func createMetric(value: Double, type: DMMetricType, subtype: DMMetricSubtype, unit: DMMetricUnit) -> DMMetric {
        let metric = DMMetric(context: context)
        metric.value = value
        metric.type = type.rawValue
        metric.subtype = subtype.rawValue
        metric.unit = unit.rawValue
        
        return metric
    }
}
