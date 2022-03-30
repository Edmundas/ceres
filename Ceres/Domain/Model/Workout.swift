//
//  Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

protocol WorkoutEnums: Hashable { }

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

extension WorkoutType: WorkoutEnums { }

enum WorkoutCategory: Int16, CaseIterable {
    case none,
         girl,
         hero
}

extension WorkoutCategory: WorkoutEnums { }

struct Workout: Identifiable {
    let id: UUID
    let createDate: Date

    let type: WorkoutType
    let category: WorkoutCategory

    let title: String

    let metrics: [Metric]
}
