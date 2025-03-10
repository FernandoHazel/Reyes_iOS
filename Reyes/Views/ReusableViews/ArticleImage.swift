//
//  ArticleView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 20/09/24.
// This view is used to notify an external view that the image already loaded

import SwiftUI
import FirebaseStorage

struct ArticleImage: View {
    var imagePath: String
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    @State private var progress: Float = 0.0
    @Binding var alreadyDownloaded: Bool // This is the only difference in this view from downloadedImage
    
    var body: some View {
        
        //The view should update on the main thread
        VStack {
            if isLoading {
                ProgressView(value: progress)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaledToFit()
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxHeight: 1500)
                    .scaledToFit()
            } else {
                Image("defaultImage")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            if (!alreadyDownloaded){
                fetchImage()
            }
        }
    }
    
    //Fetch the image with a maximum size
    private func fetchImage() {
        isLoading = true
        let storageRef = Storage.storage().reference(withPath: imagePath)
        let taskRef = storageRef.getData(maxSize: Int64(2 * 1024 * 1024)) { data, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                image = UIImage(named: "defoultImage")
                isLoading = false
                return
            }
            
            if let data = data {
                image = UIImage(data: data)
                isLoading = false
                alreadyDownloaded = true
            }
        }
        
        //Console log
        taskRef.observe(.progress) { snapshot in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            //print("You are \(pctThere) complete")
        }
    }
}


struct ArticleImage_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        private var imagePath: String = "Players/02.png"
        @State private var alreadyDownloaded = false
        

        var body: some View {
            ArticleImage(imagePath: imagePath, alreadyDownloaded: $alreadyDownloaded)
        }
    }
}

