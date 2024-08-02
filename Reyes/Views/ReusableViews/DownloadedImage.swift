import SwiftUI
import FirebaseStorage

struct DownloadedImage: View {
    @Binding var imagePath: String
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    @State private var progress: Float = 0.0
    
    var body: some View {
        
        //The view should update on the main thread
        VStack {
            if isLoading {
                ProgressView(value: progress)
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 100, height: 100)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("defaultImage")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            fetchImage()
        }
    }
    
    //Fetch the image with a maximum size of 1024 * 1024
    private func fetchImage() {
        isLoading = true
        let storageRef = Storage.storage().reference(withPath: imagePath)
        let taskRef = storageRef.getData(maxSize: Int64(1024 * 1024)) { data, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                image = UIImage(data: data)
                isLoading = false
            }
            
        }
        
        //Console log
        taskRef.observe(.progress) { snapshot in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            print("You are \(pctThere) complete")
        }
    }
}


struct DownloadedImage_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var imagePath: String = "Players/01.png"

        var body: some View {
            DownloadedImage(imagePath: $imagePath)
        }
    }
}
