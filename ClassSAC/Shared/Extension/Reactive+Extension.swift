import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {

    var viewDidLoadEvent: ControlEvent<Void> {
        let source = methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppearEvent: ControlEvent<Void> {
        let source = methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
        return ControlEvent(events: source)
    }
}
