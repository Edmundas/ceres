//
//  Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

enum WorkoutType: Int16, CaseIterable {
    case none,
         ft,
         rft,
         amrap,
         emom,
         tabata,
         fgb,
         dbr
}

enum WorkoutCategory: Int16, CaseIterable {
    case none,
         girl,
         hero
}

struct Workout: Identifiable {
    let id: UUID
    
    let type: WorkoutType
    let category: WorkoutCategory
    
    let title: String
    
    let metrics: [Metric]
}
