//
//  EditComputerView.swift
//  Melatonin
//

import SwiftUI
import SwiftData
import WakeOnLAN

struct ComputerView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var computer: Computer
    
    // Temporary fields for editing
    @State private var editingComputer: Computer
    
    // Validation error
    @State private var errorMessage: String?
    
    init(computer: Computer) {
        self.computer = computer
        self.editingComputer = Computer(name: computer.name, macAddress: computer.macAddress, lowPowerMode: computer.lowPowerMode)
    }
    
    var body: some View {
        VStack {
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Form {
                TextField("Name", text: $editingComputer.name)
                    .onChange(of: editingComputer.name) {
                        if validateInputs() { saveChanges() }
                    }
                TextField("MAC Address", text: $editingComputer.macAddress)
                    .onChange(of: editingComputer.macAddress) {
                        if validateInputs() { saveChanges() }
                    }
                Toggle("Low Power Mode", isOn: $editingComputer.lowPowerMode)
                    .onChange(of: editingComputer.lowPowerMode) {
                        if validateInputs() { saveChanges() }
                    }
            }
            .navigationTitle("Computer")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            HStack {
                Button("Wake Up") {
                    guard validateInputs() else {
                        errorMessage = "Cannot wake up computer with invalid parameters."
                        return
                    }
                    let result = sendWakeOnLAN(macAddress: computer.macAddress)
                    print(result)
                }
                .buttonStyle(.borderedProminent)
                Button("Delete", role: .destructive) {
                    deleteComputer()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            _ = validateInputs()
        }
        .onDisappear {
            if !validateInputs() {
                deleteComputer()
            }
        }
        .padding()
    }
    
    private func saveChanges() {
        computer.name = editingComputer.name
        computer.macAddress = editingComputer.macAddress
        computer.lowPowerMode = editingComputer.lowPowerMode
        try? modelContext.save()
    }
    
    private func deleteComputer() {
        modelContext.delete(computer)
        try? modelContext.save()
        dismiss()
    }
    
    private func validateInputs() -> Bool {
        if editingComputer.name.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Name cannot be empty."
            return false
        }
        
        // Validate MAC address (example regex)
        let macAddressRegex = "^[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}$"
        if !NSPredicate(format: "SELF MATCHES %@", macAddressRegex).evaluate(with: editingComputer.macAddress) {
            errorMessage = "Invalid MAC address format."
            return false
        }
        
        // Clear error message if valid
        errorMessage = nil
        return true
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Computer.self, configurations: config)
    let computer = Computer(name: "Test Computer", macAddress: "00:11:22:33:44:55", lowPowerMode: false)
    ComputerView(computer: computer)
        .modelContainer(container)
}
