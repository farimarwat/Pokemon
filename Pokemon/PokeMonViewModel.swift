//
//  PokeMonViewModel.swift
//  Pokemon
//
//  Created by mac on 31/01/2025.
//

import Foundation
import CoreData

@MainActor
class PokeMonViewModel:ObservableObject{
    enum FetchStatus{
        case notStarted
        case started
        case successful
        case error(error:Error)
    }
    
    @Published var status:FetchStatus = .notStarted
    
    var viewContext:NSManagedObjectContext
    var service = PokeMonService()
    init(controller:PersistenceController){
        self.viewContext = controller.container.viewContext
        Task{
            await fetchAllPokeMon()
        }
    }
    
    private func fetchAllPokeMon() async{
        status = .started
        do{
            guard let list = try await service.fetchAllPokeMon() else {
                status = .successful
                return
            }
    
            for item in list{
                let pokemon = Pokemon(context: viewContext)
                pokemon.id = Int16(item.id)
                pokemon.name = item.name
                pokemon.attack = Int16(item.attack)
                pokemon.defense = Int16(item.defense)
                pokemon.specialAttack = Int16(item.specialAttack)
                pokemon.specialDefense = Int16(item.specialDefense)
                pokemon.speed = Int16(item.speed)
                pokemon.sprite = item.sprite
                pokemon.shiny = item.shiny
                pokemon.types = item.types
                pokemon.organizeTypes()
                pokemon.favourite = false
               try saveData()
            }
            status = .successful
        }catch let error {
            status = .error(error: error)
            print(error)
        }
    }
    
    func saveData() throws{
        try viewContext.save()
    }
}
