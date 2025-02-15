//
//  Pokemon+Ext.swift
//  Pokemon
//
//  Created by mac on 02/02/2025.
//

import Foundation
import CoreData

extension Pokemon{
    var background:String {
        switch self.types![0] {
        case "normal","grass","electric","poison","fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock","ground","steel","fighting","ghost","dark","psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire","dragon":
            return "firedragon"
        case "flying","bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "normal"
        }
    }
    
    var stats:[Stat] {
        [
            Stat(id: 1, label: "Hp", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defence", value: self.defense),
            Stat(id: 4, label: "Special Attach", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed)
        ]
    }
    var highestStat:Stat{
        stats.max{$0.value < $1.value}!
    }
    
    func organizeTypes(){
        if types!.count == 2 && types![0] == "normal"{
            types!.swapAt(0, 1)
        }
    }
}

struct Stat:Identifiable{
    let id:Int
    let label:String
    let value:Int16
}
