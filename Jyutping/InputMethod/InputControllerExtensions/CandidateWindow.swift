import SwiftUI

extension JyutpingInputController {

        func resetWindow() {
                _ = window?.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window?.contentViewController?.children.map({ $0.removeFromParent() })
                let frame: CGRect = windowFrame()
                if window == nil {
                        window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
                        window?.backgroundColor = .clear
                        let levelValue: Int = Int(CGShieldingWindowLevel())
                        window?.level = NSWindow.Level(levelValue)
                        window?.orderFrontRegardless()
                }
                switch InputState.current {
                case .switches:
                        let switchesUI = NSHostingController(rootView: SwitchesView().environmentObject(switchesObject))
                        window?.contentView?.addSubview(switchesUI.view)
                        switchesUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor,
                           let bottomAnchor = window?.contentView?.bottomAnchor,
                           let leadingAnchor = window?.contentView?.leadingAnchor,
                           let trailingAnchor = window?.contentView?.trailingAnchor {
                                switch windowPattern {
                                case .regular:
                                        NSLayoutConstraint.activate([
                                                switchesUI.view.topAnchor.constraint(equalTo: topAnchor, constant: windowOffset),
                                                switchesUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: windowOffset)
                                        ])
                                case .horizontalReversed:
                                        NSLayoutConstraint.activate([
                                                switchesUI.view.topAnchor.constraint(equalTo: topAnchor, constant: windowOffset),
                                                switchesUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -windowOffset)
                                        ])
                                case .verticalReversed:
                                        NSLayoutConstraint.activate([
                                                switchesUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -windowOffset),
                                                switchesUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: windowOffset)
                                        ])
                                case .reversed:
                                        NSLayoutConstraint.activate([
                                                switchesUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -windowOffset),
                                                switchesUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -windowOffset)
                                        ])
                                }
                        }
                        window?.contentViewController?.addChild(switchesUI)
                        window?.setFrame(frame, display: true)
                        switchesObject.resetHighlightedIndex()
                        let expanded: CGFloat = windowOffset * 2
                        let newFrame: CGRect = {
                                guard let size: CGSize = window?.contentView?.subviews.first?.frame.size else { return frame }
                                guard size.width > 44 else { return frame }
                                let windowSize: CGSize = CGSize(width: size.width + expanded, height: size.height + expanded)
                                return windowFrame(size: windowSize)
                        }()
                        window?.setFrame(newFrame, display: true)
                default:
                        let candidatesUI = NSHostingController(rootView: CandidateBoard().environmentObject(displayObject))
                        window?.contentView?.addSubview(candidatesUI.view)
                        candidatesUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor,
                           let bottomAnchor = window?.contentView?.bottomAnchor,
                           let leadingAnchor = window?.contentView?.leadingAnchor,
                           let trailingAnchor = window?.contentView?.trailingAnchor {
                                switch windowPattern {
                                case .regular:
                                        NSLayoutConstraint.activate([
                                                candidatesUI.view.topAnchor.constraint(equalTo: topAnchor, constant: windowOffset),
                                                candidatesUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: windowOffset)
                                        ])
                                case .horizontalReversed:
                                        NSLayoutConstraint.activate([
                                                candidatesUI.view.topAnchor.constraint(equalTo: topAnchor, constant: windowOffset),
                                                candidatesUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -windowOffset)
                                        ])
                                case .verticalReversed:
                                        NSLayoutConstraint.activate([
                                                candidatesUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -windowOffset),
                                                candidatesUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: windowOffset)
                                        ])
                                case .reversed:
                                        NSLayoutConstraint.activate([
                                                candidatesUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -windowOffset),
                                                candidatesUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -windowOffset)
                                        ])
                                }
                        }
                        window?.contentViewController?.addChild(candidatesUI)
                        window?.setFrame(.zero, display: true)
                }
        }

        func windowFrame(size: CGSize = CGSize(width: 800, height: 500)) -> CGRect {
                let origin: CGPoint = currentOrigin ?? currentClient?.position ?? .zero
                let width: CGFloat = size.width
                let height: CGFloat = size.height
                let x: CGFloat = {
                        if windowPattern.isReversingHorizontal {
                                return origin.x - width - 8
                        } else {
                                return origin.x
                        }
                }()
                let y: CGFloat = {
                        if windowPattern.isReversingVertical {
                                return origin.y + 16
                        } else {
                                return origin.y - height
                        }
                }()
                return CGRect(x: x, y: y, width: width, height: height)
        }
}
