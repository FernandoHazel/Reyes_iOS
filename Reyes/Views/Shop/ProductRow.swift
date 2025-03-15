import SwiftUI

struct ProductRow: View {
    var product: Product
    @State private var alreadyDownloaded = false
    
    var body: some View {
        
        ZStack {
            ArticleImage(imagePath: product.imgNames[0], alreadyDownloaded: $alreadyDownloaded)
                .cornerRadius(10)
            if(alreadyDownloaded){
                VStack{
                    Spacer()
                    Caption(text: product.name, price: product.price, discount: product.discount)
                        .cornerRadius(10)
                }
                
            }
            
        }
    }
}

struct Caption: View {
    let text: String
    var price: Double
    let discount: Double
    
    var body: some View {
        
        VStack{
            HStack {
                
                if(discount > 0){
                    Text("$"+String(price - price * discount/100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Text("Regular: $"+String(price))
                        .font(.caption)
                        .strikethrough(true)
                        .foregroundColor(.white)
                } else {
                    Text("$"+String(price))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
            }
            Text(text)
                .bold()
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Color(.blue)
                .opacity(0.5)
            
        )
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()
        
        let product = Product(
            id: 1,
            name: "Gorra Azul",
            price: 250,
            description: "Esta es una descripción de prueba de este artículo",
            imgNames: ["Merch/Gorra_Azul.png"],
            discount: 20,
            availability: ["standard": 10],
            reward: 10
        )

        var body: some View {
            ProductRow(product: product)
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}

