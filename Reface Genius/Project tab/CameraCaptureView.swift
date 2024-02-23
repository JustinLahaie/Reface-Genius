import SwiftUI
//import UIKit

struct CameraCaptureView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    var useSamplePhoto: Bool
    var clientsViewModel: ClientsViewModel

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed (assuming a static picker UI)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, clientsViewModel: clientsViewModel)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraCaptureView
        let clientsViewModel: ClientsViewModel

        init(_ parent: CameraCaptureView, clientsViewModel: ClientsViewModel) {
            self.parent = parent
            self.clientsViewModel = clientsViewModel
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let filename = UUID().uuidString + ".jpg"
                parent.clientsViewModel.addImageToCurrentProject(image: image, filename: filename)
                
                // ***IMPORTANT:***  Update a property (e.g., 'showEditor')  in your parent view that drives   navigation here
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}
