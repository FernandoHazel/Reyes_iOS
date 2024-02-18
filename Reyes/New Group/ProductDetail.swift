import SwiftUI

struct ProductDetail: View {
    var product: Product
    
    var body: some View {
        
        VStack {
            
            CircleImage(image: product.images[0])
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    Text(product.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Text(String(product.price))
                        .font(.title)
                }
                Text("Talla: " + product.size)
                    .font(.subheadline)
                
                Divider()
                
                Text("Acerca de este producto")
                    .font(.title2)
                
                ScrollView{
                    Text(product.description)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack (alignment: .center) {
                        Button(action: {
                            //Añadir al carrito
                            //..
                            
                        }, label: {
                            Text("Añadir al carrito")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal, 5)
                                .background(
                                    Color.yellow
                                        .cornerRadius(10)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                )
                                
                    })
                        Button(action: {
                            //Comprar
                            //..
                            
                        }, label: {
                            Text("Comprar")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal, 33)
                                .background(
                                    Color.yellow
                                        .cornerRadius(10)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                )
                                
                        })
                    }
                    Spacer()
                }
                
                
                
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProductDetail(product: products[3])
}
