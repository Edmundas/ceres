//
//  Metric.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

enum MetricType: Int16, CaseIterable {
    case none,
         weight,
         height,
         distance,
         time,
         reps
}

enum MetricSubtype: Int16, CaseIterable {
    case none,
         perRound,
         totalPerRounds,
         minPerRounds,
         maxPerRounds
}

enum MetricUnit: Int16, CaseIterable {
    case none,
         rep,
         second,
         centimeter,
         meter,
         kilometer,
         inch,
         feet,
         yard,
         mile,
         kilogram,
         pound
}

struct Metric: Identifiable, Equatable {
    let id: UUID
    
    let type: MetricType
    let subtype: MetricSubtype
    let unit: MetricUnit
    
    let value: Double
}
