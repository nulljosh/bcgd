import SwiftUI

@main
struct BCGDApp: App {
    @State private var store = Store()

    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView()
                    .tabItem { Label("Dashboard", systemImage: "square.grid.2x2") }
                InventoryView()
                    .tabItem { Label("Inventory", systemImage: "shippingbox") }
                JobsView()
                    .tabItem { Label("Jobs", systemImage: "list.clipboard") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .tint(.bcgdTeal)
            .environment(store)
        }
    }
}
