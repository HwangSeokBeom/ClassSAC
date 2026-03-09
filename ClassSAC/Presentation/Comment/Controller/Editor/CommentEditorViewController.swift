//
//  CommentEditorViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentEditorViewController: UIViewController {

    private let rootView = CommentEditorRootView()
    private let viewModel: CommentEditorViewModel

    private let disposeBag = DisposeBag()

    init(viewModel: CommentEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

private extension CommentEditorViewController {

    func bind() {
        let input = CommentEditorViewModel.Input(
            viewDidLoad: Observable.just(()),
            contentTextDidChange: rootView.contentTextView.rx.text.orEmpty.asObservable(),
            didTapConfirmButton: rootView.confirmButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindState(output: output)
        bindRoute(output: output)
        bindError(output: output)
        bindAction()
    }

    func bindState(output: CommentEditorViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.render(state: state)
            }
            .disposed(by: disposeBag)
    }

    func bindRoute(output: CommentEditorViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                switch route {
                case .close:
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    func bindError(output: CommentEditorViewModel.Output) {
        output.showErrorMessage
            .emit(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }

    func bindAction() {
        rootView.backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    func render(state: CommentEditorViewState) {
        title = state.navigationTitle

        rootView.courseTitleLabel.text = state.courseTitle
        rootView.categoryTagLabel.text = state.categoryTitle

        if rootView.contentTextView.text != state.contentText {
            rootView.contentTextView.text = state.contentText
        }

        rootView.countLabel.text = state.currentCountText
        rootView.confirmButton.setTitle(state.confirmButtonTitle, for: .normal)
        rootView.confirmButton.isEnabled = state.isConfirmButtonEnabled
        rootView.confirmButton.alpha = state.isConfirmButtonEnabled ? 1.0 : 0.4

        if state.isLoading {
            rootView.loadingIndicatorView.startAnimating()
        } else {
            rootView.loadingIndicatorView.stopAnimating()
        }
    }
}
