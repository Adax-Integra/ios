import SwiftUI

struct ContentView: View {
  @EnvironmentObject var session: AuthSession

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello External User")

      Button("Cerrar sesión") {
        session.signOut()
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .environmentObject(AuthSession())
}
