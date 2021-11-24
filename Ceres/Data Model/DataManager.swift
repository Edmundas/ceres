//
//  DataManager.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

typealias DataManagerProtocol = WorkoutDataManagerProtocol

final class DataManager {
    static let shared = DataManager()
    
    let persistenceController: PersistenceController
    var context: NSManagedObjectContext { persistenceController.container.viewContext }
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
}
