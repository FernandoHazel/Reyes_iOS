import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                NextGameView()
                NewsList()
            }
        }
    }
}

#Preview {
    HomeView()
}
