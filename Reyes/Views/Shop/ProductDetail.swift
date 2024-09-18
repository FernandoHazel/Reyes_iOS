import SwiftUI
import CoreData

struct ProductDetail: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    var product: Product
    
    @State private var showAlert = false
    @State private var selectedSize: String? = nil
    @State private var quantitySelected: Int = 0
    @State private var itemAvailability: Int = 1
    @State private var showCart: Bool = false
    
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
                    
                    //1. Add the product
                    addProduct(product: product)
                    
                    //.2 Save in the memory
                    saveContext()
                    
                    //3. Show the car view
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
        .onAppear {
            
            // If this is a standard product take the availability
            if product.availability.keys.first == "standard" {
                itemAvailability = product.availability["standard"] ?? 1
            }
        }
        .padding()
        Spacer()
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addProduct(product: Product){
        withAnimation {
            let newCartProduct = CartProduct(context: viewContext)
            newCartProduct.desc = product.description
            newCartProduct.discount = product.discount
            newCartProduct.imageName = product.imgNames[0]
            newCartProduct.name = product.name
            newCartProduct.price = product.price
            newCartProduct.reward = product.reward
            newCartProduct.quantitySelected = Int64(quantitySelected)
            newCartProduct.selectedSize = selectedSize
        }
        
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could't save context while adding cart product: \(error.localizedDescription)")
        }
    }
    
    private func showCartView(){
        showCart = true
    }
}

struct ProductDetail_Previews: PreviewProvider {
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
            //availability: ["standard": 10],
            availability: ["S": 3,"M": 7,"L": 13,"XL": 5,"XXL": 12],
            reward: 10
        )

        var body: some View {
            ProductDetail(product: product)
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
