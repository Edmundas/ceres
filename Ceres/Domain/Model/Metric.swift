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
         duration,
         reps
}

extension MetricType: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:     return "none"
        case .weight:   return "Weight"
        case .height:   return "Height"
        case .distance: return "Distance"
        case .duration: return "Duration"
        case .reps:     return "Reps"
        }
    }
}

struct Metric: Identifiable, Equatable {
    let id: UUID
    let createDate: Date

    let type: MetricType

    let value: Double
}
