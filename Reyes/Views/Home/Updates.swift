import SwiftUI

struct Updates: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if(!vm.updates.isEmpty){
            ForEach(vm.updates) { update in
                NavigationLink {
                    DownloadedImage(imagePath: update.image)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                } label: {
                    DownloadedImage(imagePath: update.image)
                        .scaledToFill()
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    .padding()
                }
                .listStyle(.inset)
            }
        } else {
            FetchingView()
        }
    }
}

#Preview {
    Updates()
}
