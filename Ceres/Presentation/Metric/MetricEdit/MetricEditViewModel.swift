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

    @Published var value = ""
    @Published var type = MetricType.none {
        didSet {
            switch type {
            case .weight: unit = "Kilograms"
            case .height, .distance: unit = "Meters"
            default: unit = nil
            }
        }
    }

    @Published var unit: String?

    @Published var errorMessage = ""
    @Published var hasError = false

    init(metric: Binding<Metric?>) {
        _metric = metric

        if let currentMetric = metric.wrappedValue {
            value = currentMetric.value.formattedMetricValue
            type = currentMetric.type
        }
    }

    private func createMetric() async {
        metric = Metric(
            id: UUID(),
            createDate: Date(),
            type: type,
            value: value.metricValue
        )
    }

    private func updateMetric() async {
        guard let currentMetric = metric else { return }

        metric = Metric(
            id: currentMetric.id,
            createDate: currentMetric.createDate,
            type: type,
            value: value.metricValue
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
