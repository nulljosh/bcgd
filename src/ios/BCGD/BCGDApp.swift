import SwiftUI
import LocalAuthentication

@main
struct BCGDApp: App {
    @State private var auth = AuthStore()
    @State private var store = Store()
    @State private var unlocked = false

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.userId == nil {
                    AccountGateView()
                        .environment(auth)
                } else if unlocked {
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
                    .environment(auth)
                    .shareApp("https://doorstock.heyitsmejosh.com")
                } else {
                    LockScreen(unlocked: $unlocked)
                }
            }
            .onChange(of: unlocked) { _, isUnlocked in
                if !isUnlocked { authenticate() }
            }
            .task { if auth.userId != nil { authenticate() } }
            .onChange(of: auth.userId) { _, newValue in
                if newValue != nil { authenticate() }
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            unlocked = true // ponytail: no passcode/biometrics set on device, don't lock the shop out
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock Doorstock") { success, _ in
            DispatchQueue.main.async { unlocked = success }
        }
    }
}

// MARK: - Lock screen

private struct LockScreen: View {
    @Binding var unlocked: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield")
                .font(.system(size: 44))
                .foregroundStyle(Color.bcgdTeal)
            Text("Doorstock is locked")
                .font(.headline)
            Button("Unlock") {
                let context = LAContext()
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock Doorstock") { success, _ in
                    DispatchQueue.main.async { unlocked = success }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.bcgdTeal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
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
