import SwiftUI

struct MainTabView: View {
    // State variables to manage sheet and modal presentations
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var showingClientForm = false
    @State private var selectedTab = 0
    @State private var showingImageEditor = false

    // Initialize your view model
    @StateObject var clientsViewModel =  ClientsViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) { // ZStack for positioning the floating button
            NavigationView { // Ensures navigation features for potential future expansion
                TabView(selection: $selectedTab) {
                    ClientFoldersView(clientsViewModel: clientsViewModel, selectedTab: $selectedTab)
                        .tabItem {
                            Label("Folders", systemImage: "folder.fill")
                        }
                        .tag(0)

                    OpenProjectView(clientsViewModel: clientsViewModel)
                        .tabItem {
                            Label("Project", systemImage: "square.and.pencil")
                        }
                        .tag(1)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshade.fill")
                        }
                        .tag(2)
                }
                .navigationTitle("Your App Title") // Optional title for clarity
            }

            // Floating Button: For triggering actions based on the tab
            Button(action: {
                if selectedTab == 0 {
                    showingClientForm = true
                } else {
                    showingCamera = true
                }
            }) {
                Image(systemName: selectedTab == 0 ? "plus" : "camera")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding([.trailing, .bottom], 20)
            }
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraCaptureView(isShown: $showingCamera, image: $capturedImage, useSamplePhoto: false,
                             clientsViewModel: clientsViewModel)
                .ignoresSafeArea()
                .onDisappear {
                    if capturedImage != nil {
                        showingImageEditor = true
                    }
                }
        }
        .sheet(isPresented: $showingClientForm) {
            ClientInfoFormView(isPresented: $showingClientForm, selectedTab: $selectedTab,
                             viewModel: clientsViewModel)
        }
        .sheet(isPresented: $showingImageEditor) {
            if let image = capturedImage {
                EditorView(image: image)
                    .onDisappear {
                        capturedImage = nil
                        showingImageEditor = false
                    }
            }
        }
    }
}

// SwiftUI Preview (remains the same)
struct MainTabView_Preview: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

