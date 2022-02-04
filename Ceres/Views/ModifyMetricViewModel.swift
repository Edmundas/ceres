//
//  ModifyMetricViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation

final class ModifyMetricViewModel: ObservableObject {
    @Published var metric: DMMetric?
    @Published var value = ""
    @Published var type = DMMetricType.none
    @Published var subtype = DMMetricSubtype.none
    @Published var unit = DMMetricUnit.none
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared as DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func create() -> DMMetric {
        return dataManager.createMetric(
            value: Double(value) ?? 0.0,
            type: type,
            subtype: subtype,
            unit: unit)
    }
}
