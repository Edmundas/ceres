//
//  MetricRepository.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

protocol MetricRepository {
    func deleteMetric(_ id: UUID) async -> Result<Bool, MetricError>
    func createMetric(_ metric: Metric) async -> Result<Bool, MetricError>
    func updateMetric(_ metric: Metric) async -> Result<Bool, MetricError>
}
