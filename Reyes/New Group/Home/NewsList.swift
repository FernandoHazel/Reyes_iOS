import SwiftUI

struct NewsList: View {
    var body: some View {
        List(noticias) { noticia in
            NavigationLink {
                NewDetail(new: noticia)
            } label: {
                NewRow(new: noticia)
                    .cornerRadius(10)
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    NewsList()
}
