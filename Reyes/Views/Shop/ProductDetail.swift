import SwiftUI

struct ProductDetail: View {
    var product: Product
    
    @State private var showAlert = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView {
                Carousel(photosNames: product.imgNames)
                    .frame(maxHeight: .infinity)
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .background(Color.gray.opacity(0.3))
                
                HStack {
                    Text(product.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("$"+String(product.price))
                        .font(.title)
                }
                .padding()
                /*
                Text("Talla: " + product.size)
                    .font(.subheadline)
                 */
                Divider()
                Text("Acerca de este producto")
                    .font(.title2)
                    .bold()
                Text(product.description)
                    .padding(.top)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    //Comprar
                    //..
                    showAlert = true
                    
                }, label: {
                    Text("Comprar")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(1)
                        .background(
                            Color.yellow
                                .cornerRadius(10)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .frame(width: 300)
                        )
            })
                .alert(isPresented: $showAlert, content: {
                    Alert(
                        title: Text("La función de compra sigue en desarrollo"),
                        message: Text("Pulsa 'OK' para continuar"),
                        dismissButton: .default(Text("OK"))
                    )
                })
                Spacer()
            }
        }
        .padding()
        Spacer()
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            ProductDetail(product: vm.products[0])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
