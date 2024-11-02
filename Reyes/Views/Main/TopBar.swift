import SwiftUI

struct TopBar: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    var reyesLogo: String = "TeamLogos/Reyes_icon.png"
    @Binding var showingAuthView: Bool
    @Binding var showCart: Bool
    @State var cartIcon: String = "cart.circle"
    
    var body: some View {
        VStack {
            Image("Reyes_logo")
                .resizable()
                .frame(width: 30, height: 30)
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showingAuthView.toggle()
                    }
                
                Image(systemName: cartIcon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showCart.toggle()
                    }

                Spacer()
            }
            .padding(.horizontal)
            
        }
        .padding(.bottom)
        .background(Color(red: 0.0, green: 0.30, blue: 0.90))
        .onAppear(){
            // Change cart icon if we have products on the cart to comunicate the user that he has product to buy yet
            if let existingCartProduct = cartProducts.first{
                cartIcon = "cart.circle.fill"
            } else {
                cartIcon = "cart.circle"
            }
        }
        
    }
}

struct TopBar_Preview: PreviewProvider {
    static var previews: some View{
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State var showingAuthView = false
        @State var showCart = false
        
        var body: some View {
            TopBar(showingAuthView: $showingAuthView, showCart: $showCart)
        }
    }
}

