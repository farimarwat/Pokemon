//
//  StatView.swift
//  Pokemon
//
//  Created by mac on 02/02/2025.
//

import SwiftUI
import Charts

struct StatView: View {
    @EnvironmentObject var pokemon:Pokemon
    var body: some View {
        Chart(pokemon.stats){state in
            BarMark(
                x:.value("Value", state.value),
                y: .value("Stat", state.label)
            )
            .annotation(position:.trailing) {
                Text("\(state.value)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .foregroundColor(Color(pokemon.types![0].capitalized))
        .frame(height: 300)
    }
}

#Preview {
    StatView()
        .environmentObject(SamplePokeMon.samplePokeMon)
}
