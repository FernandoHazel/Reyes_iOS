import SwiftUI

struct NewRow: View {
    @State private var alreadyDownloaded = false
    var new: Noticia
    
    var body: some View {
        
        ArticleImage(imagePath: new.mainImageName ?? "", alreadyDownloaded: $alreadyDownloaded)
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
