//
//  Metric.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

protocol MetricEnums: Hashable { }

enum MetricType: Int16, CaseIterable {
    case none,
         weight,
         height,
         distance,
         time,
         reps
}

extension MetricType: MetricEnums { }

enum MetricSubtype: Int16, CaseIterable {
    case none,
         perRound,
         totalPerRounds,
         minPerRounds,
         maxPerRounds
}

extension MetricSubtype: MetricEnums { }

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

extension MetricUnit: MetricEnums { }

struct Metric: Identifiable, Equatable {
    let id: UUID
    let createDate: Date

    let type: MetricType
    let subtype: MetricSubtype
    let unit: MetricUnit

    let value: Double
}
