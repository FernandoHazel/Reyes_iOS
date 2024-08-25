import SwiftUI

struct RewardsOnboarding: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if(!vm.rewardsInstructions.isEmpty){
            List(vm.rewardsInstructions) { rewardInstruction in
                VStack {
                    DownloadedImage(imagePath: rewardInstruction.image)
                        .frame(width: 150, height: 100)
                    Text(rewardInstruction.title)
                        .bold()
                        .padding()
                    Text(rewardInstruction.text)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        } else {
            FetchingView()
        }
        
    }
}

#Preview {
    RewardsOnboarding()
}
