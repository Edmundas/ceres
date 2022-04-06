//
//  Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

enum WorkoutType: Int16, CaseIterable {
    case none,
         // swiftlint:disable identifier_name
         ft, // abbreviation 'for time'
         // swiftlint:enable identifier_name
         rft,
         amrap,
         emom,
         tabata,
         fgb,
         dbr
}

struct Workout: Identifiable, Equatable {
    let id: UUID
    let createDate: Date

    let type: WorkoutType

    let title: String

    let metrics: [Metric]
    let rounds: [Round]
}
