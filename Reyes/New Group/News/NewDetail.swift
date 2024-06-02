import SwiftUI

struct NewDetail: View {
    var new: Noticia
    
    var body: some View {
        ScrollView {
            Image(new.mainImageName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Text(new.by)
                    .bold()
                Spacer()
                Text(new.date)
            }
            .padding()
            VStack {
                ForEach(new.paragraphs, id: \.self) { paragraph in
                    Text(paragraph)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NewDetail(new: noticias[1])
}
