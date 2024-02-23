// Section 9.0

import SwiftUI

class Client: Identifiable {
    let id = UUID() // Automatic ID generation
    var name: String
    var projects: [Project]

    init(name: String, projects: [Project]) {
        self.name = name
        self.projects = projects
    }
}

class Project: Identifiable {
    let id = UUID()
    var name: String
    var imageIdentifiers: [String]

    init(name: String, imageIdentifiers: [String]) {
        self.name = name
        self.imageIdentifiers = imageIdentifiers
    }
}
