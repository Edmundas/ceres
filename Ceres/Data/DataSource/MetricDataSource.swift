//
//  MetricDataSource.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

protocol MetricDataSource{
    func getById(_ id: UUID) async throws -> Metric?
    func delete(_ id: UUID) async throws -> ()
    func create(metric: Metric) async throws -> ()
    func update(id: UUID, metric: Metric) async throws -> ()
}
