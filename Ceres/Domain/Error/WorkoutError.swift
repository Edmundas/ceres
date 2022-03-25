//
//  WorkoutError.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

enum WorkoutError: Error{
    case DataSourceError,
         CreateError,
         DeleteError,
         UpdateError,
         FetchError
}
