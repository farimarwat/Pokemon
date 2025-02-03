//
//  SamplePokeMon.swift
//  Pokemon
//
//  Created by mac on 01/02/2025.
//

import Foundation
import CoreData
struct SamplePokeMon{
    static let samplePokeMon = {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        let result = try! context.fetch(fetchRequest)
        return result.first!
    }()
}
