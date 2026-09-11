import SwiftUI

@main
struct BCGDApp: App {
    @State private var store = Store()
    @SceneStorage("selectedTab") private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem { Label("Dashboard", systemImage: "square.grid.2x2") }
                    .tag(0)
                InventoryView()
                    .tabItem { Label("Inventory", systemImage: "shippingbox") }
                    .tag(1)
                JobsView()
                    .tabItem { Label("Jobs", systemImage: "list.clipboard") }
                    .tag(2)
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .tag(3)
            }
            .tint(.bcgdTeal)
            .environment(store)
            .shareApp("https://bcgd.heyitsmejosh.com")
        }
    }
}

// MARK: - Share

// ponytail: one overlay rather than a per-screen toolbar button — these root views share no
// navigation container to hang a .toolbar on. Move it into a toolbar per screen if this ever
// covers something that matters.
private struct AppShareOverlay: ViewModifier {
    let link: String

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottomTrailing) {
            if let url = URL(string: link) {
                ShareLink(item: url) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .medium))
                        .padding(10)
                        .background(.regularMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .padding(16)
            }
        }
    }
}

private extension View {
    func shareApp(_ link: String) -> some View { modifier(AppShareOverlay(link: link)) }
}
