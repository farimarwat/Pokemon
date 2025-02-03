//
//  PokeMonService.swift
//  Pokemon
//
//  Created by mac on 31/01/2025.
//

import Foundation
import CoreData

struct PokeMonService{
    enum NetWorkError:Error{
        case badUrl, badResponse, badData
    }
    
    func fetchAllPokeMon() async throws -> [PokeMonResponse]? {
        if havePokemon() {
            return nil
        }
        var listPokeMon:[PokeMonResponse] = []
        let baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        var fetchUrl = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        fetchUrl?.queryItems = [
            URLQueryItem(name: "limit", value: "386")
        ]
        guard let finalUrl = fetchUrl?.url else {
            throw NetWorkError.badUrl
        }
        
        let (data,response) = try await URLSession.shared.data(from: finalUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetWorkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any], let pokeDex = pokeDictionary["results"] as? [[String:String]] else {
            throw NetWorkError.badData
        }
        
        for item in pokeDex {
            if let url = item["url"] {
                listPokeMon.append(
                    try await fetchPokeon(for: url)
                )
            }
            
        }
        
        
        return listPokeMon
    }
    
    private func fetchPokeon(for url:String) async throws -> PokeMonResponse{
        let url = URL(string: url)!
        let (data, response ) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetWorkError.badResponse
        }
        let pokemon = try JSONDecoder().decode(PokeMonResponse.self, from: data)
        print("id \(pokemon.id) name:\(pokemon.name)")
        return pokemon
    }
    
    private func havePokemon()->Bool{
        do{
            let context = PersistenceController.shared.container.newBackgroundContext()
            let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id IN %@", [1,386])
            let pokemons = try context.fetch(fetchRequest)
            if  pokemons.count == 2 {
                return true
            }
        }catch{
            print(error)
            return false
        }
        return false
    }
}
