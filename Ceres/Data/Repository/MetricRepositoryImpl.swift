//
//  MetricRepositoryImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

struct MetricRepositoryImpl: MetricRepository {
    var dataSource: MetricDataSource
    
    func deleteMetric(_ id: UUID) async -> Result<Bool, MetricError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.DeleteError)
        }
    }
    
    func createMetric(_ metric: Metric) async -> Result<Bool, MetricError> {
        do {
            try await dataSource.create(metric: metric)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }
    }
    
    func updateMetric(_ metric: Metric) async -> Result<Bool, MetricError> {
        do {
            try await dataSource.update(id: metric.id, metric: metric)
            return .success(true)
        } catch {
            return .failure(.UpdateError)
        }
    }
}
