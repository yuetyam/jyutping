import SwiftUI

struct HomeView: View {
        
        @State private var placeholdText: String = ""
        
        private let enableKeyboard: Text = Text("•  Jump to ") + Text("Settings").fontWeight(.medium) + Text("\n") +
                Text("•  Tap ") + Text("Keyboards").fontWeight(.medium) + Text("\n") +
                Text("•  Turn on ") + Text("Jyutping").fontWeight(.medium) + Text(" ") + Text("Keyboard")
        
        
        // FIXME: - iOS 14 bug?
        // workaround
        private var editingKeyboards: Text {
                if #available(iOS 14.0, *) {
                        return Text("Settings App   →   General   →   Keyboard   →   Keyboards   →   Add New Keyboards... or Edit")
                } else {
                        return editKeyboard
                }
        }
        private let editKeyboard: Text = Text("Go to ") +
                Text("Settings").fontWeight(.medium) + Text(" App   →   ") +
                Text("General").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboard").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboards").fontWeight(.medium) + Text(", then ") +
                Text("Add New Keyboards...").fontWeight(.medium) + Text(" or ") +
                Text("Edit").fontWeight(.medium) + Text("\n")
        
        var body: some View {
                NavigationView {
                        ScrollView {
                                Divider()
                                
                                TextField("Type here to test keyboards", text: $placeholdText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                
                                CardView(headline: Text("How to enable this Keyboard"), content: enableKeyboard)
                                        .padding()
                                
                                Button(action: {
                                        let url: URL = URL(string: UIApplication.openSettingsURLString)!
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }) {
                                        HStack{
                                                Spacer()
                                                Text("Open ") + Text("Settings").fontWeight(.medium) + Text(" App")
                                                Spacer()
                                        }
                                }
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
                                .padding(.horizontal)
                                
                                CardView(headline: Text("How to add or edit keyboards"), content: editingKeyboards)
                                        .padding()
                                        .padding(.top, 85)
                                        .padding(.bottom, 80)
                        }
                        .navigationBarTitle(Text("Home"))
                }
                .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                }
                .tag(0)
                .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
                HomeView()
        }
}
