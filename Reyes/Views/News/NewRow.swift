import SwiftUI

struct NewRow: View {
    @State private var alreadyDownloaded = false
    var new: Noticia
    
    var body: some View {
        
        ZStack{
            ArticleImage(imagePath: new.mainImageName ?? "", alreadyDownloaded: $alreadyDownloaded)
            if(alreadyDownloaded){
                VStack{
                    Spacer()
                    NewCaption(new: new)
                }
                
            }
        }
    }
}

struct NewCaption: View {
    let new: Noticia
    
    var body: some View {

        VStack{
            VStack{
                Text(new.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(red: 0.0, green: 0.30, blue: 0.90)
                .opacity(0.5)
            
        )
    }
}

struct NewRow_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()
        
        let noticia = Noticia(
            id: 1,
            title: "Hola título",
            mainImageName: "News/Dinos_Reyes.png",
            postLink: ""
        )

        var body: some View {
            NewRow(new: noticia)
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
