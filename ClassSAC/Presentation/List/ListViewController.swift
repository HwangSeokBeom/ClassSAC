//
//  ListViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit

final class ListViewController: UIViewController {

    private let listRootView = ListRootView()

    override func loadView() {
        view = listRootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
