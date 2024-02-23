import SwiftUI

class ClientsViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var selectedClientID: UUID?
    @Published var selectedImages: [UIImage] = []
    @Published var selectedClient: Client?
    @Published var selectedGalleryImage: UIImage?


    init() {
        // Initialize your view model here if needed
    }

    // Adds a new client to the list
    func addClient(name: String, address: String, phone: String, email: String) {
        let newClient = Client(name: name, projects: [Project(name: "Default Project", imageIdentifiers: [])])
        clients.append(newClient)
    }

    // Adds an image to the currently selected project
    func addImageToCurrentProject(image: UIImage, filename: String) {
        guard let selectedClientIndex = clients.firstIndex(where: { $0.id == selectedClientID }) else { return }
        
        // Ensure there's at least one project to add the image to
        guard !clients[selectedClientIndex].projects.isEmpty else { return }

        saveImageToDisk(image: image, filename: filename)
        // Assuming adding to the first project, adjust as necessary for your app logic
        clients[selectedClientIndex].projects[0].imageIdentifiers.append(filename)
    }

    // Saves an image to disk
    func saveImageToDisk(image: UIImage, filename: String) {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return }
        
        let filepath = directory.appendingPathComponent(filename)
        do {
            try data.write(to: filepath)
        } catch {
            print("Error saving image to disk: \(error.localizedDescription)")
        }
    }
    
    // Loads an image from disk
    func loadImage(identifier: String) -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imageURL = documentsURL.appendingPathComponent(identifier)
        return UIImage(contentsOfFile: imageURL.path)
    }

    // Optional: Add a method to update selectedClient based on selectedClientID
    func updateSelectedClient() {
        self.selectedClient = clients.first { $0.id == self.selectedClientID }
    }
}
