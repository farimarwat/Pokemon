//
//  PokeMonResponse.swift
//  Pokemon
//
//  Created by mac on 31/01/2025.
//

import Foundation

struct PokeMonResponse: Codable{
    let id:Int
    let name:String
    let types:[String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    let sprite:URL
    let shiny:URL
    
    enum PokeMonKeys:String,CodingKey{
        case id, name, stats,types, sprites
        
        enum TypeDictionaryKeys:String, CodingKey{
            case type
            
            enum TypeKeys:String, CodingKey{
                case name
            }
        }
        
        enum StatDictionaryKeys:String, CodingKey{
            case stat
            case value = "base_stat"
            
            enum StatKeys:String, CodingKey{
                case name
            }
        }
        
        enum SpritKeys:String, CodingKey{
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: PokeMonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        //getting types
        var decodedTypes:[String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokeMonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokeMonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        types = decodedTypes
        
        //getting states
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd{
            let statDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokeMonKeys.StatDictionaryKeys.self)
            let statContainer = try statDictionaryContainer.nestedContainer(keyedBy: PokeMonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            let name = try statContainer.decode(String.self, forKey: .name)
            switch name {
            case "hp":
                hp = try statDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefense = try statDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("it will never trigger")
            }
        }
        
        //sprites
        let spritesContainer = try container.nestedContainer(keyedBy: PokeMonKeys.SpritKeys.self,forKey:.sprites)
        sprite = try spritesContainer.decode(URL.self, forKey: .sprite)
        shiny = try spritesContainer.decode(URL.self, forKey: .shiny)
    }
}
