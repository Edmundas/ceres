//
//  ModifyMetricViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation
import SwiftUI

final class ModifyMetricViewModel: ObservableObject {
    @Binding var metric: DMMetric?
    
    @Published var value = ""
    @Published var type = DMMetricType.none
    @Published var subtype = DMMetricSubtype.none
    @Published var unit = DMMetricUnit.none
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared as DataManagerProtocol, metric: Binding<DMMetric?>) {
        self.dataManager = dataManager
        _metric = metric

        if let currentMetric = metric.wrappedValue {
            value = String(currentMetric.value)
            type = DMMetricType(rawValue: currentMetric.type) ?? .none
            subtype = DMMetricSubtype(rawValue: currentMetric.subtype) ?? .none
            unit = DMMetricUnit(rawValue: currentMetric.unit) ?? .none
        }
    }
    
    func save() {
        if let currentMetric = metric {
            currentMetric.value = Double(value) ?? 0.0
            currentMetric.type = type.rawValue
            currentMetric.subtype = subtype.rawValue
            currentMetric.unit = unit.rawValue
        } else {
            metric = dataManager.createMetric(
                value: Double(value) ?? 0.0,
                type: type,
                subtype: subtype,
                unit: unit
            )
        }
    }
    
    func cancel() {
        metric = nil
    }
}
