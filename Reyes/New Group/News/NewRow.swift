import SwiftUI

struct NewRow: View {
    var new: Noticia
    
    var body: some View {
        
        Image(new.mainImageName)
            .resizable()
            .scaledToFill()
            .overlay(alignment: .bottom){
                NewCaption(new: new)
            }
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            .padding()
        
    }
}

struct NewCaption: View {
    let new: Noticia
    
    var body: some View {
        VStack{
            Text(new.title)
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .offset(y: -20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(new.subTitle)
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: -20)
                .padding(.horizontal)
                .padding(.bottom)
                
        }
        .background(
            Color.blue.opacity(0.6)
                .frame(width: 500, height: 200)
            
        )
        .padding(0)
    }
}

#Preview {
    NewRow(new: noticias[0])
}
