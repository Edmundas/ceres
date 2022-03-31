//
//  Round.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation

struct Round: Identifiable, Equatable {
    let id: UUID

    let orderNumber: Int

    let movements: [Movement]
}