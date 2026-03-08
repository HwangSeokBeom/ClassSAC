//
//  ViewDidLoad+Reactive.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
        return ControlEvent(events: source)
    }
}
