//
//  MovementDefinitionError.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

enum MovementDefinitionError: Error {
    case dataSourceError,
         createError,
         deleteError,
         updateError,
         fetchError
}
