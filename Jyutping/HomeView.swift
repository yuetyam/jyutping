import SwiftUI

struct HomeView: View {
        
        @State private var placeholdText: String = ""
        
        private let enableKeyboard: Text = Text("•  Jump to ") + Text("Settings").fontWeight(.medium) + Text("\n") +
                Text("•  Tap ") + Text("Keyboards").fontWeight(.medium) + Text("\n") +
                Text("•  Turn on ") + Text("Jyutping").fontWeight(.medium) + Text(" ") + Text("Keyboard")
        
        private let editingKeyboards: Text = Text("Go to ") +
                Text("Settings").fontWeight(.medium) + Text(" App   →   ") +
                Text("General").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboard").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboards").fontWeight(.medium) + Text(", then ") +
                Text("Add New Keyboards...").fontWeight(.medium) + Text(" or ") +
                Text("Edit").fontWeight(.medium)
        
        var body: some View {
                NavigationView {
                        ScrollView {
                                Divider()
                                
                                TextField("Type here to test keyboards", text: $placeholdText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                
                                VStack {
                                        HStack {
                                                Text("How to enable this Keyboard")
                                                        .lineLimit(1)
                                                        .font(.system(size: 20, weight: .medium, design: .default))
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                        
                                        HStack {
                                                enableKeyboard.fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                        }
                                }
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
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
                                
                                VStack {
                                        HStack {
                                                Text("How to add or edit keyboards")
                                                        .lineLimit(1)
                                                        .font(.system(size: 20, weight: .medium, design: .default))
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                        
                                        HStack {
                                                editingKeyboards.fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                        }
                                }
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
                                .padding()
                                .padding(.vertical, 85)
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
