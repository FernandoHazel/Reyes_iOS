//
//  RewardsOnboarding.swift
//  Reyes
//
//  Created by Fernando Ascencio on 02/06/24.
//

import SwiftUI

struct RewardsOnboarding: View {
    var body: some View {
        List(rewardsInstructions) { rewardInstruction in
            VStack {
                Image(rewardInstruction.image)
                    .resizable()
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
