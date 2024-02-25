import SwiftUI

struct ProductDetail: View {
    var product: Product
    
    var body: some View {
        
        VStack {
            
            Carousel(photosNames: product.imgNames)
                .frame(maxHeight: .infinity)
                .frame(height: UIScreen.main.bounds.height / 3)
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    Text(product.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("$"+String(product.price))
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
                    
                    
                    
                        Button(action: {
                            //Añadir al carrito
                            //..
                            
                        }, label: {
                            Text("Añadir al carrito")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal, 5)
                                .background(
                                    Color.yellow
                                        .cornerRadius(10)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                        .frame(width: UIScreen.main.bounds.width / 2.5)
                                )
                                
                    })
                        
                    
                    Spacer()
                    
                        Button(action: {
                            //Comprar
                            //..
                            
                        }, label: {
                            Text("Comprar")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal, 5)
                                .background(
                                    Color.yellow
                                        .cornerRadius(10)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                        .frame(width: UIScreen.main.bounds.width / 2.5)
                                )
                                
                        })
                        
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
    ProductDetail(product: products[1])
}
