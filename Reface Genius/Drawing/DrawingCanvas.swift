import SwiftUI

struct DrawingCanvas: View {
    @Binding var currentDrawing: Drawing
    @Binding var drawings: [Drawing]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for drawing in drawings {
                    addDrawing(drawing, toPath: &path)
                }
                addDrawing(currentDrawing, toPath: &path)
            }
            .stroke(Color.black, lineWidth: 2)
            .background(Color.clear)
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { value in
                        let newPoint = value.location
                        currentDrawing.points.append(newPoint)
                    }
                    .onEnded { _ in
                        drawings.append(currentDrawing)
                        currentDrawing = Drawing()
                    }
            )
        }
    }
    
    private func addDrawing(_ drawing: Drawing, toPath path: inout Path) {
        guard let firstPoint = drawing.points.first else { return }
        path.move(to: firstPoint)
        for point in drawing.points.dropFirst() {
            path.addLine(to: point)
        }
    }
}

//struct Drawing {
//    var points: [CGPoint] = []
//}
