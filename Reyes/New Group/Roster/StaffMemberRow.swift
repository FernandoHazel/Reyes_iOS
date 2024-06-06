import SwiftUI

struct StaffMemberRow: View {
    var staffMember: StaffMember
    
    var body: some View {
        HStack {
            
            Image(staffMember.profileImageName)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack {
                Text(staffMember.name)
                    .bold()
                    .font(.system(size: 14))
                
            }
            
            Spacer()
            
            Text(staffMember.rol)
                .bold()
                .font(.system(size: 20))
        }
        Divider()
    }
}

#Preview {
    StaffMemberRow(staffMember: staff[0])
}
