import SwiftUI

class Links {
    
    static let shared = Links()
    
    static let winStarData = "https://squidluckygames.top/data"
    
    @AppStorage("finalUrl") var finalURL: URL?
    
    
}
