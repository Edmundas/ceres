//
//  DataFormatter.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-06.
//

import Foundation

extension Double {
    var formattedMetricValue: String {
        return NumberFormatter.metricValueFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension String {
    var metricValue: Double {
        return NumberFormatter.metricValueFormatter.number(from: self)?.doubleValue ?? 0.0
    }
}

extension NumberFormatter {
    static var metricValueFormatter: NumberFormatter {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.minimumFractionDigits = 0
        nFormatter.maximumFractionDigits = 3
        return nFormatter
    }
}

extension DateComponentsFormatter {
    static var metricDurationFormatter: DateComponentsFormatter {
        let dFormatter = DateComponentsFormatter()
        dFormatter.unitsStyle = .abbreviated
        dFormatter.allowedUnits = [.hour, .minute, .second]
        return dFormatter
    }
}
