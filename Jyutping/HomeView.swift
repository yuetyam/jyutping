import SwiftUI

struct HomeView: View {
        
        private let placeholder: String = NSLocalizedString("Type here to test keyboards", comment: "")
        @State private var cacheText: String = ""
        
        private var isJyutpingKeyboardEnabled: Bool {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
        }
        
        var body: some View {
                NavigationView {
                        ZStack {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                ScrollView {
                                        EnhancedTextField(placeholder: placeholder, text: $cacheText)
                                                .padding(8)
                                                .fillBackground()
                                                .padding()
                                        /* TODO
                                        if !isJyutpingKeyboardEnabled {
                                                GuideView()
                                        }
                                        */
                                        GuideView()
                                }
                                .navigationBarTitle(Text("Home"))
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
                HomeView()
        }
}

private struct GuideView: View {
        
        private let enableKeyboard: Text = Text("•  Jump to ") + Text("Settings").fontWeight(.medium) + Text("\n") +
                Text("•  Tap ") + Text("Keyboards").fontWeight(.medium) + Text("\n") +
                Text("•  Turn on ") + Text("Jyutping").fontWeight(.medium) + Text(" ") + Text("Keyboard") + Text("\n") +
                Text("•  Turn on ") + Text("Allow Full Access").fontWeight(.medium)
        
        private let editingKeyboards: Text = Text("Go to ") +
                Text("Settings").fontWeight(.medium) + Text(" App   →   ") +
                Text("General").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboard").fontWeight(.medium) + Text("   →   ") +
                Text("Keyboards").fontWeight(.medium) + Text(", then ") +
                Text("Add New Keyboards...").fontWeight(.medium) + Text(" or ") +
                Text("Edit").fontWeight(.medium)
        
        var body: some View {
                VStack {
                        HStack {
                                Text("How to enable this Keyboard").font(.system(size: 20, weight: .medium))
                                Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                                enableKeyboard.fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                }
                .padding()
                .fillBackground()
                .padding()
                
                Button(action: {
                        if let url: URL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                        }
                }) {
                        HStack{
                                Spacer()
                                Text("Open ") + Text("Settings").fontWeight(.medium) + Text(" App")
                                Spacer()
                        }
                }
                .padding()
                .fillBackground()
                .padding(.horizontal)
                .padding(.bottom)
                
                VStack {
                        HStack {
                                Text("How to add or edit keyboards").font(.system(size: 20, weight: .medium))
                                Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                                editingKeyboards.fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
