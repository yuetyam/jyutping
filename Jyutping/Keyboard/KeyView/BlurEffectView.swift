import UIKit

final class BlurEffectView: UIVisualEffectView {

        private var fraction: CGFloat = 0.5
        private var effectStyle: UIBlurEffect.Style = .light

        override func didMoveToSuperview() {
                backgroundColor = .clear
                setupBlur()
        }
        private let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        private func setupBlur() {
                animator.stopAnimation(true)
                effect = nil
                animator.addAnimations { [weak self] in
                        self?.effect = UIBlurEffect(style: self?.effectStyle ?? .light)
                }
                animator.fractionComplete = fraction   // blur intensity in range 0 - 1
        }

        convenience init(fraction: CGFloat, effectStyle: UIBlurEffect.Style) {
                self.init()
                self.fraction = fraction
                self.effectStyle = effectStyle
        }
        deinit {
                animator.stopAnimation(true)
        }
}
