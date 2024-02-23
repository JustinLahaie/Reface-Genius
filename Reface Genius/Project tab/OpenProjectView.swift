import SwiftUI

struct OpenProjectView: View {
    @ObservedObject var clientsViewModel: ClientsViewModel
    @State private var showImagePicker = false

    var body: some View {
        ScrollView {
            VStack {
                ProjectImagesView(clientsViewModel: clientsViewModel)

                // Button to pick images
                Button("Select Images from Gallery") {
                    showImagePicker = true
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImages: $clientsViewModel.selectedImages,
                        selectedProject: clientsViewModel.selectedClient?.projects.first,
                        clientsViewModel: clientsViewModel) // Pass the view model here

        }
    }
}

struct ProjectImagesView: View {
    @ObservedObject var clientsViewModel: ClientsViewModel

    var body: some View {
        if let selectedClient = clientsViewModel.selectedClient,
           let selectedProject = selectedClient.projects.first {
            ForEach(selectedProject.imageIdentifiers, id: \.self) { imageIdentifier in
                // You'll need to implement a way to load images from their identifiers
                if let image = clientsViewModel.loadImage(identifier: imageIdentifier) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }
        } else {
            Text("No project selected or no images available")
                .foregroundColor(.gray)
        }
    }
}

// Note: Ensure ClientsViewModel and PhotoPicker are defined to work with this setup.
