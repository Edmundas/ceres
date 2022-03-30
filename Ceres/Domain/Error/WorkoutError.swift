//
//  WorkoutError.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

enum WorkoutError: Error {
    case dataSourceError,
         createError,
         deleteError,
         updateError,
         fetchError
}
