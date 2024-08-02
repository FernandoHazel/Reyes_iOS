import SwiftUI

struct RewardsOnboarding: View {
    var body: some View {
        List(rewardsInstructions) { rewardInstruction in
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
    }
}

#Preview {
    RewardsOnboarding()
}
