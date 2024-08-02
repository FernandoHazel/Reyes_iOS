import SwiftUI

struct ProductRow: View {
    var product: Product
    
    var body: some View {
        
        DownloadedImage(imagePath: product.imgNames[0])
            .scaledToFit()
            .overlay(alignment: .bottom){
                Caption(text: product.name, price: product.price)
            }
            .padding()
            .background(Color.gray.opacity(0.3))
        
    }
}

struct Caption: View {
    let text: String
    let price: Double
    
    var body: some View {
        HStack{
            Text(text)
                .font(.title)
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
            
            Spacer()
            
            Text("$"+String(price))
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                
        }
        .background(
            Color.blue.opacity(0.3)
                .frame(width: 500, height: 100)
            
        )
        .padding(0)
        
            

    }
}

#Preview {
    ProductRow(product: products[0])
}
