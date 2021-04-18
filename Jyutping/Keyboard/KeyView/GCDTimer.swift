import Foundation

class GCDTimer {
        private let timer: DispatchSourceTimer
        typealias TimerHandler = (GCDTimer) -> Void
        init(interval: DispatchTimeInterval, repeats: Bool = true, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping TimerHandler) {
                timer = DispatchSource.makeTimerSource(queue: queue)
                timer.setEventHandler { [weak self] in
                        if self != nil {
                                handler(self!)
                        }
                }
                if repeats {
                        timer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
                } else {
                        timer.schedule(deadline: .now() + interval, leeway: leeway)
                }
        }
        private lazy var isRunning = false
        deinit {
                if !isRunning {
                        // crash if .cancel()
                        timer.resume()
                }
        }
        func start() {
                if !isRunning {
                        timer.resume()
                        isRunning = true
                }
        }
        func suspend() {
                if isRunning {
                        timer.suspend()
                        isRunning = false
                }
        }
}
