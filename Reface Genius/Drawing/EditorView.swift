import SwiftUI

struct EditorView: View {
    var imageToEdit: IdentifiableImage?
    @State private var currentDrawing: Drawing = Drawing()
    @State private var drawings: [Drawing] = []
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        NavigationView {
            VStack {
                if let image = imageToEdit {
                    ZStack {
                        Image(uiImage: imageToEdit?.image ?? UIImage()) // Using optional unwrapping with fallback

                            .resizable()
                            .scaledToFit()

                        DrawingCanvas(currentDrawing: $currentDrawing, drawings: $drawings)
                    }
                } else {
                    // Placeholder: Replace with image button, indicator, etc.
                    Text("No Image for Editing")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                saveEditedImage()
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveEditedImage() {
        if let editedImage = getEditedImage() {
            UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
        } else {
            // Handle the case where there was no editing (optional):
            // - Display an alert
            // - Modify save logic based on editing state
        }
    }

    private func getEditedImage() -> UIImage? {
        if let imageToEdit = imageToEdit {
            let renderer = UIGraphicsImageRenderer(size: imageToEdit.image.size)
            return renderer.image { ctx in
                imageToEdit.image.draw(at: CGPoint.zero)


                ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                ctx.cgContext.setLineWidth(2)

                for drawing in drawings {
                    addDrawing(drawing, toContext: ctx.cgContext)
                }
                addDrawing(currentDrawing, toContext: ctx.cgContext)
            }
        } else {
            return nil
        }
    }

    private func addDrawing(_ drawing: Drawing, toContext context: CGContext) {
        guard let firstPoint = drawing.points.first else { return }
        context.move(to: firstPoint)
        for point in drawing.points.dropFirst() {
            context.addLine(to: point)
        }
    }
}
