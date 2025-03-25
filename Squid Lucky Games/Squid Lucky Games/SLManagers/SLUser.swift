import SwiftUI

class SLUser: ObservableObject {
    
    static let shared = SLUser()
    
    @AppStorage("money") var storedMoney: Int = 3000
    @Published var money: Int = 3000
    
    init() {
        money = storedMoney
    }
    
    
    func updateUserBirds(for coins: Int) {
        self.money += coins
        storedMoney = self.money
    }
    
    func minusUserBirds(for money: Int) {
        self.money -= money
        if self.money < 0 {
            self.money = 0
        }
        storedMoney = self.money
        
    }
    
}
