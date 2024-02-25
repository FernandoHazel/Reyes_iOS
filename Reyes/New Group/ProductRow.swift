import SwiftUI

struct ProductRow: View {
    var product: Product
    
    var body: some View {
        
        Image(product.imgNames[0])
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottom){
                Caption(text: product.name, price: product.price)
            }
            .padding()
        
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
    Group{
        ProductRow(product: products[0])
        ProductRow(product: products[4])
    }
    
}
