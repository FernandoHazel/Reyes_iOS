import SwiftUI

struct CircleImage: View {
    var body: some View {
        
        VStack {
            Image("gorra-azul")
                .resizable() // Make the image resizable
                .scaledToFit() // Scale the image to fit within its frame
                .frame(width: 200, height: 200)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay {
                    Circle().stroke(.yellow, lineWidth: 4)
                }
                .shadow(radius: 7)
        }
        
    }
}

#Preview {
    CircleImage()
}
