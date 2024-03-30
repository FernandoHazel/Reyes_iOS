//
//  CustomTabBar.swift
//  Reyes
//
//  Created by Fernando Ascencio on 28/03/24.
//

import SwiftUI

// Here I have my tab bar cases (should be the same name as the SF Symbols)
enum Tab: String, CaseIterable {
    case house
    case storefront
    case calendar
    case person
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        
        // The calendar filled is called "calendar.circle.fill"
        if (selectedTab.rawValue == "calendar"){
            return selectedTab.rawValue + ".circle.fill"
        } else {
            return selectedTab.rawValue + ".fill"
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: tab == selectedTab ? fillImage : tab.rawValue)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .background(Color.blue)

        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.house))
}
