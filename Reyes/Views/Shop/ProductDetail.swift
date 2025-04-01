import SwiftUI
import CoreData

struct ProductDetail: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var product: Product
    
    @State private var showAlert = false
    @State private var selectedSize: String? = nil
    @State private var quantitySelected: Int = 0
    @State private var itemAvailability: Int = 0
    @State private var showCart: Bool = false
    @State private var mustAuthenticate: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView {
                Carousel(photosNames: product.imgNames)
                    .frame(maxHeight: .infinity)
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .background(Color.gray.opacity(0.3))
                
                HStack {
                    Text(product.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("$"+String(product.price - product.price * product.discount/100))
                        .font(.title)
                }
                HStack{
                    Text("Recompensa")
                        .font(.title2)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text("\(Int(product.reward))")
                        .font(.title2)
                        .foregroundColor(.green)
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                }
                
                Divider()
                
                VStack{
                    // Only choose size if apply
                    if let firstKey = product.availability.keys.first, firstKey != "standard" {
                        Text("Elige la talla")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            // for each size create a size button
                            ForEach(product.availability.sorted(by: >), id: \.key) { talla, cantidad in
                                VStack {
                                    Button(action: {
                                        selectedSize = talla
                                        itemAvailability = product.availability[selectedSize!] ?? 1
                                        if(quantitySelected > itemAvailability){
                                            quantitySelected = itemAvailability
                                        }
                                    }, label: {
                                        Text("\(talla)")
                                            .frame(minWidth: 50, minHeight: 50)
                                            .background(selectedSize == talla ? Color.blue : Color.clear)
                                            .foregroundColor(selectedSize == talla ? .white : .blue)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue, lineWidth: 2)
                                            )
                                    })
                                }
                            }
                        }
                        
                        // Display a warning if we have few items left
                        if(selectedSize != nil){
                            if (itemAvailability <= 5){
                                Text("Ya solo quedan \(itemAvailability) unidades")
                                    .padding()
                                    .foregroundColor(.red)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
                        }
                        
                    } else {
                        // Display a warning if there are no items available
                        if (itemAvailability <= 0){
                            Text("Lo sentimos, por el momento el artículo no está disponible en el inventario.")
                                .padding()
                                .foregroundColor(.red)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        }
                    }
                    
                    // select the quantity of items
                    Text("Elige la cantidad")
                        .font(.title2)
                        .bold()
                        .padding()
                    // Do not let to buy more than the available
                    Stepper("\(quantitySelected)", value: $quantitySelected, in: 0...itemAvailability)
                                    .padding()
                    
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    
                    // if the user hasn't choosed a size and quantity for a sized item display an alert
                    if product.availability.keys.first != "standard" && selectedSize == nil || quantitySelected <= 0 {
                        showAlert = true
                        return
                    }
                    
                    // if the user is not authenticated display auth view
                    if authViewModel.authenticationState != AuthenticationState.authenticated {
                        mustAuthenticate = true
                        return
                    }
                    
                    let productId = String(product.id)
                    let size = selectedSize ?? "standard"
                    let quantity = quantitySelected
                    
                    // Add the product
                    authViewModel.addSelectedProduct(productId: productId, size: size, quantity: quantity)
                    
                    // Show the car view
                    showCartView()
                    
                }, label: {
                    Text("Añadir al carrito")
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
                        title: Text("Selecciona la talla y la cantidad"),
                        message: Text("Debes seleccionar al menos una talla y una cantidad para continuar"),
                        dismissButton: .default(Text("OK"))
                    )
                })
                Spacer()
            }
        }
        .sheet(isPresented: $showCart) {
            Cart()
        }
        .sheet(isPresented: $mustAuthenticate) {
            AuthenticationView()
        }
        .onAppear {
            // If this is a standard product take the availability
            if product.availability.keys.first == "standard" {
                itemAvailability = product.availability["standard"] ?? 1
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    private func showCartView(){
        showCart = true
    }
}
