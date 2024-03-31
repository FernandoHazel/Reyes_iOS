import SwiftUI

struct NewRow: View {
    var new: Noticia
    
    var body: some View {
        
        Image(new.mainImageName)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottom){
                NewCaption(text: new.title)
            }
            .padding()
            .background(Color.gray.opacity(0.3))
        
    }
}

struct NewCaption: View {
    let text: String
    
    var body: some View {
        HStack{
            Text(text)
                .font(.title)
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                
        }
        .background(
            Color.blue.opacity(0.3)
                .frame(width: 500, height: 100)
            
        )
        .padding(0)
    }
}

#Preview {
    NewRow(new: noticias[0])
}
