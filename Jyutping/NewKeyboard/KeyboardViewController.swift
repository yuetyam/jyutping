import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        override func updateViewConstraints() {
                super.updateViewConstraints()
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                updateScreenSize()
                let motherBoard = UIHostingController(rootView: MotherBoard().environmentObject(self))
                view.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        motherBoard.view.topAnchor.constraint(equalTo: view.topAnchor),
                        motherBoard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        motherBoard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        motherBoard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                motherBoard.view.backgroundColor = view.backgroundColor
                self.addChild(motherBoard)
        }

        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
        }

        override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
        }

        override func textWillChange(_ textInput: UITextInput?) {
                // The app is about to change the document's contents. Perform any preparation here.
        }
        override func textDidChange(_ textInput: UITextInput?) {
                // The app has just changed the document's contents, the document context has been updated.
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                updateScreenSize()
                let newKeyboardAppearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
                if keyboardAppearance != newKeyboardAppearance {
                        keyboardAppearance = newKeyboardAppearance
                }
                let newKeyboardInterface: KeyboardInterface = adoptKeyboardInterface()
                if keyboardInterface != newKeyboardInterface {
                        keyboardInterface = newKeyboardInterface
                }
        }


        // MARK: - Input

        @Published private(set) var inputStage: InputStage = .standby

        func clearBufferText() {
                bufferText = .empty
        }
        func updateBufferText(to text: String) {
                bufferText = text
        }
        private(set) lazy var bufferText: String = .empty {
                didSet {
                        switch (oldValue.isEmpty, bufferText.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                        case (false, true):
                                inputStage = .ending
                        case (false, false):
                                inputStage = .ongoing
                        }
                        switch bufferText.first {
                        case .none:
                                break
                        case .some("r"):
                                break
                        case .some("v"):
                                break
                        case .some("x"):
                                break
                        case .some("q"):
                                break
                        default:
                                break
                        }
                }
        }


        // MARK: - Properties

        private(set) lazy var isPhone: Bool = UITraitCollection.current.userInterfaceIdiom == .phone
        private(set) lazy var isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        @Published private(set) var screenSize: CGSize = CGSize(width: 375, height: 667)
        @Published private(set) var widthUnit: CGFloat = 37.5
        @Published private(set) var heightUnit: CGFloat = 53
        private func updateScreenSize() {
                screenSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
                widthUnit = screenSize.width / 10.0
                // TODO: Responsible height
                heightUnit = 53
        }

        @Published private(set) var keyboardType: KeyboardType = .cantonese(.lowercased)
        func updateKeyboardType(to type: KeyboardType) {
                keyboardType = type
        }

        private(set) lazy var keyboardAppearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
        private(set) lazy var keyboardInterface: KeyboardInterface = adoptKeyboardInterface()
        private func adoptKeyboardInterface() -> KeyboardInterface {
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let width: CGFloat = UIScreen.main.bounds.size.width
                        let height: CGFloat = UIScreen.main.bounds.size.height
                        let isPortrait: Bool = width < height
                        let minSide: CGFloat = min(width, height)
                        if minSide > 840 {
                                return isPortrait ? .padPortraitLarge : .padLandscapeLarge
                        } else if minSide > 815 {
                                return isPortrait ? .padPortraitMedium : .padLandscapeMedium
                        } else {
                                return isPortrait ? .padPortraitSmall : .padLandscapeSmall
                        }
                default:
                        switch traitCollection.verticalSizeClass {
                        case .compact:
                                return .phoneLandscape
                        default:
                                return .phonePortrait
                        }
                }
        }


        // MARK: - Haptic Feedback

        private lazy var hapticFeedback: UIImpactFeedbackGenerator? = nil
        private func instantiateHapticFeedback() {
                switch hapticFeedbackMode {
                case .disabled:
                        hapticFeedback = nil
                case .light:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                case .medium:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
                case .heavy:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
                }
        }
        func prepareHapticFeedback() {
                hapticFeedback?.prepare()
        }
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
        }
        private func releaseHapticFeedback() {
                hapticFeedback = nil
        }

        private(set) lazy var hapticFeedbackMode: HapticFeedback = {
                guard hasFullAccess else { return .disabled }
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.HapticFeedback)
                switch savedValue {
                case HapticFeedback.disabled.rawValue:
                        return .disabled
                case HapticFeedback.light.rawValue:
                        return .light
                case HapticFeedback.medium.rawValue:
                        return .medium
                case HapticFeedback.heavy.rawValue:
                        return .heavy
                default:
                        return .disabled
                }
        }()
        func updateHapticFeedbackMode(to mode: HapticFeedback) {
                hapticFeedbackMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.HapticFeedback)
                instantiateHapticFeedback()
        }
}
