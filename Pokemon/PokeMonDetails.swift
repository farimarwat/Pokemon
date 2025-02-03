//
//  PokeMonDetails.swift
//  Pokemon
//
//  Created by mac on 01/02/2025.
//

import SwiftUI

struct PokeMonDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon:Pokemon
    @State var showShiny = false
    var body: some View {
        ScrollView{
            ZStack{
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 7)
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .shadow(color:.black,radius: 7)
                        .padding(.top, 60)
                } placeholder: {
                    ProgressView()
                }
            }
            HStack{
                ForEach(pokemon.types!,id: \.self){type in
                    Text(type.capitalized)
                        .font(.title2)
                        .padding([.top,.bottom],8)
                        .padding([.leading,.trailing],20)
                        .background(Color(type.capitalized))
                        .cornerRadius(20)
                }
                Spacer()
                Button{
                    pokemon.favourite.toggle()
                    do{
                        try viewContext.save()
                    }catch{
                        print(error)
                    }
                }label: {
                    Image(systemName: pokemon.favourite ? "star.fill" : "star")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            
            Text("Stats")
                .bold()
                .font(.title2)
            StatView()
                .padding()
                
        }
        .navigationTitle(pokemon.name!)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    showShiny.toggle()
                }label:{
                    if showShiny{
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
    PokeMonDetails()
        .environmentObject(SamplePokeMon.samplePokeMon)
}
