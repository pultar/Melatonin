//
//  ContentView.swift
//  Melatonin
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Computer.name) var computers: [Computer]
    @State private var path = [Computer]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(computers) { computer in
                NavigationLink(value: computer) {
                    Text(computer.name)
                }
            }
            .navigationTitle("Computers")
            .navigationDestination(for: Computer.self) { computer in
                ComputerView(computer: computer)
            }
            .toolbar {
                Button("Add Computer", systemImage: "plus") {
                    addComputerStub()
                }
            }
        }
    }
    
    private func addComputerStub() {
        let computer = Computer(name: "", macAddress: "", lowPowerMode: true)
        modelContext.insert(computer)
        try? modelContext.save()
        path = [computer]
    }

}

#Preview {
    ContentView()
}
