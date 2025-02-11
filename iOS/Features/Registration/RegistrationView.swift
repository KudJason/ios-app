import SwiftUI

struct RegistrationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                Text("Wallabag")
                    .font(.title)
                NavigationLink("Log in", destination: ServerView())
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
            }.navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }
#endif
