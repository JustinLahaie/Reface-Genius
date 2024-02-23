import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    var selectedProject: Project?
    @ObservedObject var clientsViewModel: ClientsViewModel

    @State private var imageForEditing: IdentifiableImage? // To drive  navigation (`.sheet`)

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // No dynamic updates needed in this basic version
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, clientsViewModel: clientsViewModel)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        let clientsViewModel: ClientsViewModel

        init(_ parent: PhotoPicker, clientsViewModel: ClientsViewModel) {
            self.parent = parent
            self.clientsViewModel = clientsViewModel
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else { return }

            if let result = results.first,
               result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.imageForEditing = IdentifiableImage(image: image) // Wrap using IdentifiableImage

                            // You might also update self.parent.selectedImages here if needed
                        }
                    } else {
                        // Handle image loading error (display a message, etc.)
                    }
                }
            }
        }
    }
}
