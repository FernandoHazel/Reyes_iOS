import SwiftUI

struct NewDetail: View {
    var new: Noticia
    
    var body: some View {
        ScrollView {
            DownloadedImage(imagePath: new.mainImageName)
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

struct NewDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            NewDetail(new: vm.noticias[0])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
