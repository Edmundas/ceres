//
//  MetricEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import SwiftUI

class MetricEditViewModel: ObservableObject {
    @Binding var metric: Metric?
    
    @Published var value = ""
    @Published var type = MetricType.none
    @Published var subtype = MetricSubtype.none
    @Published var unit = MetricUnit.none
    
    @Published var errorMessage = ""
    @Published var hasError = false
    
    init(metric: Binding<Metric?>) {
        _metric = metric
        
        if let currentMetric = metric.wrappedValue {
            value = String(currentMetric.value)
            type = currentMetric.type
            subtype = currentMetric.subtype
            unit = currentMetric.unit
        }
    }
    
    func save() {
        if metric != nil {
            metric = Metric(
                id: metric!.id,
                type: type,
                subtype: subtype,
                unit: unit,
                value: Double(value) ?? 0.0
            )
        } else {
            metric = Metric(
                id: UUID(),
                type: type,
                subtype: subtype,
                unit: unit,
                value: Double(value) ?? 0.0
            )
        }
    }
    
    func cancel() {
        metric = nil
    }
}
