import SwiftUI

class ShopViewModelSL: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "Item 1", image: "birdYellow", icon: "itemIcon1"),
        Item(name: "Item 2", image: "birdYellow", icon: "itemIcon2"),
        Item(name: "Item 3", image: "birdYellow", icon: "itemIcon3"),
        Item(name: "Item 4", image: "birdYellow", icon: "itemIcon4"),
        Item(name: "Item 5", image: "birdYellow", icon: "itemIcon5"),
        Item(name: "Item 6", image: "birdYellow", icon: "itemIcon6"),
    ]
    
    
    @Published var boughtItems: [Item] = [
        Item(name: "Item 1", image: "birdYellow", icon: "itemIcon1"),
    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @Published var currentTeamItem: Item? {
        didSet {
            saveTeam()
        }
    }
    
    init() {
        loadTeam()
        loadBoughtItem()
    }
    
    private let userDefaultsTeamKey = "saveCurrentItem"
    private let userDefaultsBoughtKey = "boughtItem"

    
    func saveTeam() {
        if let currentItem = currentTeamItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsTeamKey)
            }
        }
    }
    
    func loadTeam() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsTeamKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentTeamItem = loadedItem
        } else {
            currentTeamItem = shopTeamItems[0]
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var icon: String
}
