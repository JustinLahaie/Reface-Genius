// ClientInfoFormView.swift

import SwiftUI

struct ClientInfoFormView: View {
    @Binding var isPresented: Bool
    @Binding var selectedTab: Int  // Add binding for selectedTab
    @ObservedObject var viewModel: ClientsViewModel

    @State private var clientName: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Client Details")) {
                    TextField("Name", text: $clientName)
                    TextField("Address", text: $address)
                    TextField("Phone", text: $phone)
                    TextField("Email", text: $email)
                }
                Section {
                    Button("Save") {
                        viewModel.addClient(name: clientName, address: address, phone: phone, email: email)
                        isPresented = false
                        selectedTab = 1  // Switch to OpenProjectView tab after saving
                    }
                }
            }
            .navigationBarTitle("New Client", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
