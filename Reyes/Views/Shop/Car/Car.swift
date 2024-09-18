//
//  Cart.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 17/09/24.
//

import SwiftUI

struct Cart: View {
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    var body: some View {
        if (!cartProducts.isEmpty){
            ScrollView {
                ForEach(cartProducts) { cartProduct in
                    Text(cartProduct.name ?? "")
                }.onDelete(perform: deleteCartProduct)
            }
            HStack{
                Spacer()
                Button(action: {
                    
                    // Checkout
                    //..
                    
                }, label: {
                    Text("Checkout")
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
                Spacer()
            }
            

        } else {
            Text("Aún no has añadido ningún producto")
        }
        
    }
    
    private func deleteCartProduct(offsets: IndexSet){
        withAnimation {
            offsets.map { cartProducts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Could't save context while adding cart product: \(error.localizedDescription)")
            }
            
        }
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {

        var body: some View {
            Cart()
        }
    }
}
