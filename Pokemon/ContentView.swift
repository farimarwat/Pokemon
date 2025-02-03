//
//  ContentView.swift
//  Pokemon
//
//  Created by mac on 15/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel:PokeMonViewModel = PokeMonViewModel(controller: PersistenceController.shared)
   
    @FetchRequest(
        entity: Pokemon.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath:\Pokemon.id, ascending: true)]
    ) private var list:FetchedResults<Pokemon>
    
    @FetchRequest(
        entity: Pokemon.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favourite = %d", true)
    ) private var favorities:FetchedResults<Pokemon>
    
    @State var showFavourite = false
    
    var body: some View {
        switch viewModel.status  {
        case .successful:
            NavigationStack {
                List(showFavourite ? favorities : list){ pokemon in
                    NavigationLink(value:pokemon){
                        AsyncImage(url: pokemon.sprite) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100,height: 100)
                        
                        Text(pokemon.name!)
                        
                        if pokemon.favourite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing){
                        Button{
                            withAnimation {
                                showFavourite.toggle()
                            }
                        }label: {
                            Label("Filter by favourites",systemImage: showFavourite ? "star.fill" : "star")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .navigationTitle(Text("Pokemon"))
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokeMonDetails()
                        .environmentObject(pokemon)
                }
            }
        default:
            ProgressView()
        }
        
    }
    
    
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
