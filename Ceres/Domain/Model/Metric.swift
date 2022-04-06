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

struct Metric: Identifiable, Equatable {
    let id: UUID
    let createDate: Date

    let type: MetricType

    let value: Double
}
