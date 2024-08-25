import SwiftUI

//This view was used to upload json local data to the db
struct UploadButtons: View {
    var body: some View {
        Button(action: {
            //setUpdates()
        }, label: {
            Text("Upload")
        })
    }
}

#Preview {
    UploadButtons()
}
