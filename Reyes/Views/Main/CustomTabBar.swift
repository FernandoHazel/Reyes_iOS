import SwiftUI

// Here I have my tab bar cases (should be the same name as the SF Symbols)
enum Tab: String, CaseIterable {
    case house
    case book
    case bag
    case calendar
    case person
}

//Add this icon for the academy = figure.american.football

struct CustomTabBar: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
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
                    VStack {
                        Image(systemName: tab == selectedTab ? fillImage : tab.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal)
                            .padding(.top)
                            .foregroundColor(.white)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                        let iconText: String = {
                            switch tab.rawValue {
                            case "house": return "Inicio"
                            case "book": return "Academia"
                            case "bag": return "Tienda"
                            case "calendar": return "Calendario"
                            case "person": return "Roster"
                            default: return ""
                            }
                        }()
                        
                        Text(iconText)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
            }
            
            
            // Invitación a darse de alta
            AuthenticatedView()
                .environmentObject(viewModel)
        }
        .background(Color(red: 0.0, green: 0.30, blue: 0.90))
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.house))
}

// Convert hex color into sRGB
extension Color {
    init (hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
