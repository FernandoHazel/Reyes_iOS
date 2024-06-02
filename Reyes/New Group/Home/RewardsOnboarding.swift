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
                    .frame(width: 200, height: 200)
                    .padding()
                Text(rewardInstruction.title)
                    .bold()
                Text(rewardInstruction.text)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    RewardsOnboarding()
}
