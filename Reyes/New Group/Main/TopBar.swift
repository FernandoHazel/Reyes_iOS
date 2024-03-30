import SwiftUI

struct TopBar: View {
    @Binding var showingProfile: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    showingProfile.toggle()
                }

            Spacer()
            Image("Reyes_icon")
                .resizable()
                .frame(width: 60, height: 60)
                .offset(x: -30)

            Spacer()
        }
        .padding(.bottom)
        .background(Color(hex: 014791))
    }
}

/*#Preview {
    TopBar(showingProfile: false)
}*/
