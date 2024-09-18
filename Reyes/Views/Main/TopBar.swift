import SwiftUI

struct TopBar: View {
    var reyesLogo: String = "TeamLogos/Reyes_icon.png"
    @Binding var showingProfile: Bool
    @Binding var showCart: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    //showingProfile.toggle()
                }
            Image(systemName: "cart.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    showCart.toggle()
                }

            Spacer()
            DownloadedImage(imagePath: reyesLogo)
                .frame(width: 60, height: 60)
                .offset(x: -30)

            Spacer()
        }
        .padding(.bottom)
        //.background(Color(hex: 014791))
        .background(Color(red: 0.0, green: 0.30, blue: 0.90))
    }
}

struct TopBar_Preview: PreviewProvider {
    static var previews: some View{
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State var showingProfile = false
        @State var showCart = false
        
        var body: some View {
            TopBar(showingProfile: $showingProfile, showCart: $showCart)
        }
    }
}

