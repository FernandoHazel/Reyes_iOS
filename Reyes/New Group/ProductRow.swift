import SwiftUI

struct ProductRow: View {
    var product: Product
    
    var body: some View {
        HStack{
            product.images[0]
                .resizable()
                .frame(width: 50, height: 50)
            Text(product.name)
            
            Spacer()
        }
        
    }
}

#Preview {
    Group{
        ProductRow(product: products[0])
        ProductRow(product: products[1])
    }
    
}
