import SwiftUI
import WebKit

struct VideoView: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: videoURL)
        uiView.load(request)
    }
}

#Preview {
    VideoView(videoURL: URL(string: "https://www.youtube.com/embed/6aLNQhQ6G2Y?si=W6H4AzUmkmrby-M-")!)
        .frame(width: 400, height: 300)
}
