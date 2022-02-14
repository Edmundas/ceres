//
//  ModifyMetricViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import Foundation

final class ModifyMetricViewModel: ObservableObject {
    
    @Published var value = ""
    @Published var type = DMMetricType.none
    @Published var subtype = DMMetricSubtype.none
    @Published var unit = DMMetricUnit.none
    
//    var metric: DMMetric? {
//        get {
//            dataManager.createMetric(
//                value: Double(value) ?? 0.0,
//                type: type,
//                subtype: subtype,
//                unit: unit)
//        }
//        set {
//            value = String(newValue?.value ?? 0.0)
//            type = DMMetricType(rawValue: newValue?.type ?? DMMetricType.none.rawValue)!
//            subtype = DMMetricSubtype(rawValue: newValue?.subtype ?? DMMetricSubtype.none.rawValue)!
//            unit = DMMetricUnit(rawValue: newValue?.unit ?? DMMetricUnit.none.rawValue)!
//        }
//    }
    
    private let dataManager: DataManagerProtocol
    
//    private var metric: DMMetric? {
////        willSet {
//////            value = String(metric?.value ?? 0.0)
//////            type = DMMetricType(rawValue: metric?.type ?? DMMetricType.none.rawValue)!
//////            subtype = DMMetricSubtype(rawValue: metric?.subtype ?? DMMetricSubtype.none.rawValue)!
//////            unit = DMMetricUnit(rawValue: metric?.unit ?? DMMetricUnit.none.rawValue)!
////        }
//        get {
//            return nil
//        }
//        set {
//
//        }
//    }
    
    init(dataManager: DataManagerProtocol = DataManager.shared as DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
}
