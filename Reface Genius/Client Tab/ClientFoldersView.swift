// ClientFoldersView.swift

import SwiftUI

struct ClientFoldersView: View {
    @ObservedObject var clientsViewModel: ClientsViewModel
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            List(clientsViewModel.clients) { client in
                Button(client.name) {
                    clientsViewModel.selectedClient = client
                    selectedTab = 1  // Navigate to OpenProjectView tab
                }
            }
            .navigationTitle("Clients")
        }
    }
}
