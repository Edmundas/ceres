//
//  MetricError.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

enum MetricError: Error {
    case DataSourceError,
         CreateError,
         DeleteError,
         UpdateError,
         FetchError
}
