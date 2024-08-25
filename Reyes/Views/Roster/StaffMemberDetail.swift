import SwiftUI

struct StaffMemberDetail: View {
    var staffMember: StaffMember
    
    var body: some View {
        ScrollView {
            DownloadedImage(imagePath: staffMember.profileImageName)
                .scaledToFit()
            
            HStack {
                Text(staffMember.name)
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("\(String(staffMember.age)) años")
                    .bold()
                    .font(.title2)
                
            }

            .padding()
            Text("Sobre mí")
                .bold()
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if(staffMember.about != []){
                    ForEach(staffMember.about, id: \.self) { paragraph in
                        Text(paragraph)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }else{
                    Text("No hay información disponible")
                }
            }

            
            if(staffMember.imgNames != []){
                Carousel(photosNames: staffMember.imgNames)
                    .frame(width: 400, height: 300)
            } else {
                Text("No hay fotos disponibles")
                    .padding(20)
            }
            
        }
    }
}

struct StaffMemberDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            StaffMemberDetail(staffMember: vm.staff[0])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}



