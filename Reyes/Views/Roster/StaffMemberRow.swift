import SwiftUI

struct StaffMemberRow: View {
    var staffMember: StaffMember
    
    var body: some View {
        HStack {
            
            DownloadedImage(imagePath: staffMember.profileImageName)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack {
                Spacer()
                HStack {
                    Text(staffMember.name)
                        .bold()
                        .font(.system(size: 20))
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(staffMember.rol)
                        .bold()
                        .font(.system(size: 14))
                    Spacer()
                }
                
                Spacer()
            }
            Spacer()
        }
        Divider()
    }
}

#Preview {
    StaffMemberRow(staffMember: staff[0])
}
