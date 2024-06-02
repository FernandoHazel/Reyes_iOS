import SwiftUI

struct NewsList: View {
    var body: some View {
        
        NavigationView {
            List(noticias) { noticia in
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
        
    }
}

#Preview {
    NewsList()
}
