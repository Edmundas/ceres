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

extension WorkoutType: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:   return "none"
        case .ft:     return "FT"
        case .rft:    return "RFT"
        case .amrap:  return "AMRAP"
        case .emom:   return "EMOM"
        case .tabata: return "TABATA"
        case .fgb:    return "FGB"
        case .dbr:    return "DBR"
        }
    }
}

struct Workout: Identifiable, Equatable {
    let id: UUID
    let createDate: Date

    let type: WorkoutType

    let title: String

    let metrics: [Metric]
    let rounds: [Round]
}
