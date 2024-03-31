import SwiftUI

struct NewsList: View {
    var body: some View {
        ForEach(noticias) { noticia in
            NavigationLink {
                NewDetail(new: noticia)
            } label: {
                NewRow(new: noticia)
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    NewsList()
}
