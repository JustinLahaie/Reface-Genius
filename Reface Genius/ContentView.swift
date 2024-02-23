import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var imageToEdit: UIImage? // Optional for placeholder when no edit is in progress
    @State private var pickedImages: [UIImage] = []
    @State private var imageForEditing: IdentifiableImage? // To enable `.sheet` navigation
    @State private var selectedProject: Project?
    @ObservedObject var clientsViewModel = ClientsViewModel()

    var body: some View {
        MainTabView()
            .sheet(item: $imageForEditing) { imageWrapper in // sheet driven by 'imageForEditing'
                if let image = imageWrapper {
                    EditorView(imageToEdit: image)
                } else {
                    Text("No Image Available") // Placeholder
                }
            }
            .overlay(alignment: .bottom) {
                if imageForEditing != nil {  // Show PhotoPickerContentView when an image is set
                    PhotoPickerContentView(selectedImages: $pickedImages,
                                       imageForEditing: $imageForEditing,
                                       selectedProject: selectedProject,
                                       clientsViewModel: clientsViewModel)
                }
            }
    }
}

#Preview {
    ContentView()
}
