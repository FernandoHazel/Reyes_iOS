import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        
        VStack {
            image
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
    CircleImage(image: Image("sudadera-amarilla"))
}
