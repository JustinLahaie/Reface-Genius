// Section 10.0

import SwiftUI

struct ClientProjectsView: View {
    var client: Client

    var body: some View {
        List(client.projects) { project in
            Text(project.name) // Placeholder for project representation
        }
        .navigationTitle(client.name)
    }
}
