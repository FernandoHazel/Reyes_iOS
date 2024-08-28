import SwiftUI

struct ProductRow: View {
    var product: Product
    
    var body: some View {
        
        VStack {
            DownloadedImage(imagePath: product.imgNames[0])
                .frame(width: 250, height: 250)
                .cornerRadius(10)
                .padding()
            
            Caption(text: product.name, price: product.price, discount: product.discount)
                .frame(width: 250, height: 100)
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
                        .foregroundColor(.red)
                    Text("Regular: $"+String(price))
                        .font(.caption)
                        .strikethrough(true)
                } else {
                    Text("$"+String(price))
                        .font(.title)
                        .fontWeight(.bold)
                }
                
            }
            Spacer()
            Text(text)
                .font(.subheadline)
            Spacer()

        }
        .padding(0)
        
            

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
            size: "L",
            description: "Esta es una descripción de prueba de este artículo",
            imgNames: ["Merch/Gorra_Azul.png"],
            discount: 20
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
