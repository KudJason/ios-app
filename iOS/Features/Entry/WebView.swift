import CoreData
import SafariServices
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var entry: Entry
    private(set) var wkWebView = WKWebView(frame: .zero)
    @EnvironmentObject var appSetting: AppSetting

    func makeCoordinator() -> Coordinator {
        Coordinator(self, appSetting: appSetting)
    }

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        @CoreDataViewContext var context: NSManagedObjectContext
        var appSetting: AppSetting

        private var webView: WebView

        init(_ webView: WebView, appSetting: AppSetting) {
            self.webView = webView
            self.appSetting = appSetting
            super.init()
        }

        func webViewToLastPosition() {
            DispatchQueue.main.async {
                self.webView.wkWebView.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.webView.entry.screenPositionForWebView), animated: true)
            }
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            webViewToLastPosition()
            webView.fontSizePercent(appSetting.webFontSizePercent)
        }

        func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let urlTarget = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            let urlAbsolute = urlTarget.absoluteString

            if urlAbsolute.hasPrefix(Bundle.main.bundleURL.absoluteString) || urlAbsolute == "about:blank" {
                decisionHandler(.allow)
                return
            }

            if navigationAction.targetFrame?.isMainFrame == false {
                decisionHandler(.allow)
                return
            }

            let safariController = SFSafariViewController(url: urlTarget)
            safariController.modalPresentationStyle = .overFullScreen

            UIApplication.shared.open(urlTarget, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            context.perform {
                self.webView.entry.screenPosition = Float(scrollView.contentOffset.y)
                try? self.context.save()
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.scrollView.delegate = context.coordinator
        wkWebView.load(content: entry.content, justify: false)

        return wkWebView
    }

    func updateUIView(_ webView: WKWebView, context _: Context) {
        webView.fontSizePercent(appSetting.webFontSizePercent)
    }
}

#if DEBUG
    struct WebView_Previews: PreviewProvider {
        static var entry: Entry = {
            let entry = Entry()
            entry.title = "Test"
            entry.content = "<p>Nice Content</p>"
            return entry
        }()

        static var previews: some View {
            Group {
                WebView(
                    entry: entry
                ).colorScheme(.light)
                WebView(
                    entry: entry
                ).colorScheme(.dark)
            }
        }
    }
#endif
