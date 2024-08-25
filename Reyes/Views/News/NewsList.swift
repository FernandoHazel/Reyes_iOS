import SwiftUI

struct NewsList: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        if(!vm.noticias.isEmpty){
            NavigationView {
                List(vm.noticias) { noticia in
                    NavigationLink {
                        NewDetail(new: noticia)
                    } label: {
                        NewRow(new: noticia)
                            .cornerRadius(10)
                    }
                }
                .navigationTitle("Noticias")
                .listStyle(.inset)
            }
        } else {
            FetchingView()
        }
    }
}

struct NewList_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            NewsList()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
