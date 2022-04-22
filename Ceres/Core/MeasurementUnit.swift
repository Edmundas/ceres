//
//  MeasurementUnit.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-22.
//

import Foundation

enum MeasurementUnit: Int16, CaseIterable {
    case none,
         kilograms,
         meters,
         hours,
         minutes,
         seconds
}

extension MeasurementUnit: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:       return ""
        case .kilograms:  return "Kilograms"
        case .meters:     return "Meters"
        case .hours:      return "Hours"
        case .minutes:    return "Minutes"
        case .seconds:    return "Seconds"
        }
    }

    var descriptionAbbreviation: String {
        switch self {
        case .none:       return ""
        case .kilograms:  return "kg"
        case .meters:     return "m"
        case .hours:      return "h"
        case .minutes:    return "m"
        case .seconds:    return "s"
        }
    }
}
