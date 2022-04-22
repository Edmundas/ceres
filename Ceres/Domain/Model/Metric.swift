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
        case .none:     return "None"
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

extension Metric {
    var displayableValue: String {
        switch self.type {
        case .none, .reps:
            return self.value.formattedMetricValue
        case .weight:
            return self.value.formattedMetricValue + " " + MeasurementUnit.kilograms.descriptionAbbreviation
        case .height:
            return self.value.formattedMetricValue + " " + MeasurementUnit.meters.descriptionAbbreviation
        case .distance:
            return self.value.formattedMetricValue + " " + MeasurementUnit.meters.descriptionAbbreviation
        case .duration:
            return DateComponentsFormatter.metricDurationFormatter.string(from: self.value) ?? ""
        }
    }
}
