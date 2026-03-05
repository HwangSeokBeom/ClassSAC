//
//  BaseRootView.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import UIKit

class BaseRootView: UIView, ViewDesignProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        
    }

    func configureLayout() {
        
    }

    func configureView() {
        
    }
}
