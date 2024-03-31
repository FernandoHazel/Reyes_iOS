import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NextGameView()
                NewsList()
            }
        }
    }
}

#Preview {
    HomeView()
}
