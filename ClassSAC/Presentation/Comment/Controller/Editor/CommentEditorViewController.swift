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
   // private let viewDidLoadRelay = PublishRelay<Void>()

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
        //viewDidLoadRelay.accept(())
    }
}

private extension CommentEditorViewController {

    var contentTextDidChange: Observable<String> {
        NotificationCenter.default.rx
            .notification(UITextView.textDidChangeNotification, object: rootView.contentTextView)
            .compactMap { [weak self] _ in
                self?.rootView.contentTextView.text
            }
    }
    
    func bind() {
        let input = CommentEditorViewModel.Input(
            viewDidLoad: Observable.just(()),
            contentTextDidChange: contentTextDidChange,
            didTapConfirmButton: rootView.confirmButton.rx.tap.asObservable(),
            didTapBackButton: rootView.closeButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindInitialContent(output: output)
        bindState(output: output)
        bindRoute(output: output)
        bindError(output: output)
        bindPlaceholder()
    }

    func bindInitialContent(output: CommentEditorViewModel.Output) {
        output.initialContentText
            .emit(with: self) { owner, text in
                owner.rootView.contentTextView.text = text
                owner.rootView.updatePlaceholderVisibility(isHidden: !text.isEmpty)
            }
            .disposed(by: disposeBag)
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
                    owner.dismiss(animated: true)
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

    func bindPlaceholder() {
        NotificationCenter.default.rx
            .notification(UITextView.textDidChangeNotification, object: rootView.contentTextView)
            .compactMap { [weak self] _ in
                self?.rootView.contentTextView.text
            }
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(with: self) { owner, isHidden in
                owner.rootView.updatePlaceholderVisibility(isHidden: isHidden)
            }
            .disposed(by: disposeBag)
    }

    func render(state: CommentEditorViewState) {
        rootView.navigationTitleLabel.text = state.navigationTitle
        rootView.categoryTagLabel.text = state.categoryTitle
        rootView.courseTitleLabel.text = state.courseTitle
        rootView.countLabel.text = state.countText
        rootView.updateConfirmButtonTitle(state.confirmButtonTitle)

        rootView.confirmButton.isEnabled = state.isConfirmButtonEnabled
        rootView.confirmButton.alpha = state.isConfirmButtonEnabled ? 1.0 : 0.4

        if state.isLoading {
            rootView.loadingIndicatorView.startAnimating()
        } else {
            rootView.loadingIndicatorView.stopAnimating()
        }
    }
}
