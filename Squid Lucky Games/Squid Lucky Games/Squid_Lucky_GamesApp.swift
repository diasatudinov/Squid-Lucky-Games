
import SwiftUI

@main
struct Squid_Lucky_GamesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootViewSL()
                .preferredColorScheme(.light)
        }
    }
}
