//
//  MetricEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import SwiftUI

@MainActor
class MetricEditViewModel: ObservableObject {
    @Binding var metric: Metric?

    @Published var value1 = ""
    @Published var value2 = ""

    @Published var type = MetricType.none {
        didSet {
            switch type {
            case .weight:
                unit1 = MeasurementUnit.kilograms.description
                unit2 = nil
            case .height, .distance:
                unit1 = MeasurementUnit.meters.description
                unit2 = nil
            case .duration:
                unit1 = MeasurementUnit.minutes.description
                unit2 = MeasurementUnit.seconds.description
            default:
                unit1 = nil
                unit2 = nil
            }
        }
    }

    @Published var unit1: String?
    @Published var unit2: String?

    @Published var errorMessage = ""
    @Published var hasError = false

    init(metric: Binding<Metric?>) {
        _metric = metric

        if let currentMetric = metric.wrappedValue {
            if currentMetric.type == .duration {
                let duration = currentMetric.value
                let seconds = duration.truncatingRemainder(dividingBy: 60.0)
                let minutes = (duration - seconds) / 60.0

                value1 = minutes.formattedMetricValue
                value2 = seconds.formattedMetricValue
            } else {
                value1 = currentMetric.value.formattedMetricValue
            }
            type = currentMetric.type
        }
    }

    private func createMetric() async {
        var value: Double

        if type == .duration {
            value = value1.metricValue * 60.0 + value2.metricValue
        } else {
            value = value1.metricValue
        }

        metric = Metric(
            id: UUID(),
            createDate: Date(),
            type: type,
            value: value
        )
    }

    private func updateMetric() async {
        guard let currentMetric = metric else { return }

        var value: Double

        if currentMetric.type == .duration {
            value = value1.metricValue * 60.0 + value2.metricValue
        } else {
            value = value1.metricValue
        }

        metric = Metric(
            id: currentMetric.id,
            createDate: currentMetric.createDate,
            type: type,
            value: value
        )
    }

    func save() {
        if metric != nil {
            Task { await updateMetric() }
        } else {
            Task { await createMetric() }
        }
    }
}
