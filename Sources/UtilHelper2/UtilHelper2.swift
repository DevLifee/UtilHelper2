import SwiftUI

@available(iOS 14.0, *)
public struct UtilTwo: View {
    public init(listData: [String: String], pushTo: @escaping (String) -> ()) {
        self.listData = listData
        self.pushTo = pushTo
    }
    
    var pushTo: (String) -> ()
    var listData: [String: String] = [:]
    @State var next_screen_two = false
    @State var load_hide_two = false
    @State public var check_pw_two: String = ""
    @State var please_wait = true
    
    public var body: some View {
        ZStack {
            if next_screen_two {
                Color.clear.onAppear {
                    self.pushTo(check_pw_two)
                }
            } else {
                if load_hide_two {
                    ProgressView("")
                }
                
                if please_wait {
                    ProgressView("")
                }
                
                ZStack {
                    TwoCoor(url: URL(string: listData[RemoKey.rmlink10.rawValue] ?? ""), listData: self.listData, next_screen_two: $next_screen_two, load_hide_two: $load_hide_two, check_pw_two: $check_pw_two)
                        .opacity(load_hide_two ? 0 : 1)
                        .opacity(please_wait ? 0 : 1)
                }.zIndex(2)
            }
        }.foregroundColor(Color.black)
            .background(Color.white)
            .onAppear {
                timeTwoRun()
            
            }
            
            
        }
    
    func timeTwoRun() {
        please_wait = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            please_wait = false
        }
    }
}
