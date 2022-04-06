//
//  Movement.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation

struct Movement: Identifiable, Equatable {
    let id: UUID

    let orderNumber: Int

    let movementDefinition: MovementDefinition?
    let metrics: [Metric]
}
