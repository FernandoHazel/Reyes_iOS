import SwiftUI
import FirebaseStorage

struct FetchImagesTest: View {
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No Image")
                    .frame(width: 200, height: 200)
                    .background(Color.gray)
            }
            
            //Upload funcionality
            Button(action: {
                //Define the storage reference path
                let uploadReference = Storage.storage().reference(withPath: "Players/100.png")
                //Convert the image from a data object to a png
                let image = UIImage(named: "100.png")
                guard let imageData = image?.pngData() else {
                    print("No se pudo leer la imagen")
                    return
                }
                //Upload metadata
                let uploadMetada = StorageMetadata.init()
                uploadMetada.contentType = "image/png"
                
                //Upload image, we store it in a variable to observe the task
                let taskReference = uploadReference.putData(imageData, metadata: uploadMetada) { (downloadMetadata, error) in
                    if let error = error {
                        print("Error uploading the data: \(error.localizedDescription)")
                        return
                    }
                    print("IMAGE PUT IS COMPLETE: \(downloadMetadata)")
                }
                
                //Observe the progress reference
                taskReference.observe(.progress) { /*[weak self]*/ (snapshot) in
                    guard let pctThere = snapshot.progress?.fractionCompleted else { return }
                    print("You are \(pctThere) complete")
                    
                    //Show progress on progress view
                    //self.progressView.progress = Float(pctThere) // I have no progress view at the moment
                }
                
            }, label: {
                Text("Upload")
            })
            .padding()
            
            //Download functionality
            Button(action: {
                //Define the storage reference path
                let storageRef = Storage.storage().reference(withPath: "Players/99.png")
                //Set a maximum size to reject very large files, we can also observe the task
                let taskRef = storageRef.getData(maxSize: 20 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        image = UIImage(data: data)
                    }
                }
                
                //Observe the progress reference
                taskRef.observe(.progress) { /*[weak self]*/ (snapshot) in
                    guard let pctThere = snapshot.progress?.fractionCompleted else { return }
                    print("You are \(pctThere) complete")
                    
                    //Show progress on progress view
                    //self.progressView.progress = Float(pctThere) // I have no progress view at the moment
                }
                
            }, label: {
                Text("Download")
            })
        }
        .padding()
    }
}

#Preview {
    FetchImagesTest()
}
