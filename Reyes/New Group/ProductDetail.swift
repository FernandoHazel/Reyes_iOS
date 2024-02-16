import SwiftUI

struct ProductView: View {
    var body: some View {
        
        VStack {
            
            CircleImage()
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    Text("Producto")
                        .font(.title)
                    
                    Spacer()
                    
                    Text("$150")
                        .font(.title)
                }
                Text("Talla L")
                    .font(.subheadline)
                
                Divider()
                
                Text("Acerca de este producto")
                    .font(.title2)
                
                ScrollView{
                    Text("Este es el texto que describe las características del producto")
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
    }
}

#Preview {
    ProductView()
}
