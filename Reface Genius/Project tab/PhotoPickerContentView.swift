import SwiftUI
import PhotosUI

struct PhotoPickerContentView: View {
    @Binding var selectedImages: [UIImage]
    @State var imageForEditing: IdentifiableImage? // Now an optional
    var selectedProject: Project? // If relevant
    @ObservedObject var clientsViewModel: ClientsViewModel // If relevant

    var body: some View {
        VStack {
            PhotoPickerRepresentable(selectedImages: $selectedImages, imageForEditing: $imageForEditing)
        }
    }
}

// Representable to wrap PHPickerViewController
struct PhotoPickerRepresentable: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var imageForEditing: UIImage?

    //  Customization Point: Add more parameters if needed  (filters, project references, etc.)

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Updates if you later change configuration dynamically
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerRepresentable

        init(_ parent: PhotoPickerRepresentable) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) // Usually dismiss the picker

            guard let result = results.first,
                  result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
                      // Error Handling: Image wasn't loadable?
                      return
            }

            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        // You have multiple options:
                        // 1. Direct to editing
                        self.parent.imageForEditing = image

                        // 2. Add to the array
                        // self.parent.selectedImages.append(image)

                        // 3. Other logic based on your model & workflow
                    }
                }
            }
        }
    }
}
