import SwiftUI

struct ProductRow: View {
    var product: Product
    
    var body: some View {
        
        HStack {
            DownloadedImage(imagePath: product.imgNames[0])
                .frame(width: 100, height: 100)
                /*.overlay(alignment: .bottom){
                    Caption(text: product.name, price: product.price)
                }*/
                .padding()
                //.background(Color.gray.opacity(0.3))
            
            Caption(text: product.name, price: product.price)
        }
        
        
    }
}

struct Caption: View {
    let text: String
    let price: Double
    
    var body: some View {
        
        VStack{
            Spacer()
            HStack {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Text("$"+String(price))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.red)
                Spacer()
            }
            Spacer()
        }
        /*
        .background(
            Color.blue.opacity(0.3)
                .frame(width: 500, height: 100)
            
        )*/
        .padding(0)
        
            

    }
}

#Preview {
    ProductRow(product: products[0])
}
