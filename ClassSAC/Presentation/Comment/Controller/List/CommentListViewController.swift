//
//  CommentListViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentListViewController: UIViewController {

    private let rootView = CommentListRootView()
    private let viewModel: CommentListViewModel
    private let thumbnailProvider: CourseThumbnailProviding
    private weak var courseFlowCoordinator: CourseFlowCoordinating?

    private let disposeBag = DisposeBag()

    private let editCommentIDRelay = PublishRelay<String>()
    private let deleteCommentIDRelay = PublishRelay<String>()
    private let confirmDeleteRelay = PublishRelay<Void>()

    init(
        viewModel: CommentListViewModel,
        thumbnailProvider: CourseThumbnailProviding,
        courseFlowCoordinator: CourseFlowCoordinating
    ) {
        self.viewModel = viewModel
        self.thumbnailProvider = thumbnailProvider
        self.courseFlowCoordinator = courseFlowCoordinator
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
        configureTableView()
        bind()
    }
}

private extension CommentListViewController {

    func configureTableView() {
        rootView.commentTableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
    }

    func bind() {
        let input = CommentListViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapLatestSortButton: rootView.latestSortButton.rx.tap.asObservable(),
            didTapOldestSortButton: rootView.oldestSortButton.rx.tap.asObservable(),
            didTapWriteButton: rootView.writeCommentButton.rx.tap.asObservable(),
            didTapEditButton: editCommentIDRelay.asObservable(),
            didTapDeleteButton: deleteCommentIDRelay.asObservable(),
            didConfirmDeleteAlert: confirmDeleteRelay.asObservable(),
            didReceiveCommentDidChangeNotification: NotificationCenter.default.rx
                .notification(.commentDidChange)
                .map { _ in }
        )

        let output = viewModel.transform(input: input)

        bindState(output: output)
        bindTableView(output: output)
        bindRoute(output: output)
        bindDeleteAlert(output: output)
        bindError(output: output)
        bindAction()
    }

    func bindState(output: CommentListViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.render(state: state)
            }
            .disposed(by: disposeBag)
    }

    func bindTableView(output: CommentListViewModel.Output) {
        output.state
            .map(\.commentCellViewModels)
            .drive(
                rootView.commentTableView.rx.items(
                    cellIdentifier: CommentTableViewCell.identifier,
                    cellType: CommentTableViewCell.self
                )
            ) { [weak self] _, commentCellViewModel, cell in
                guard let self else { return }

                cell.configure(
                    viewModel: commentCellViewModel,
                    thumbnailProvider: self.thumbnailProvider
                )

                cell.onTapEditButton = { [weak self] commentID in
                    self?.editCommentIDRelay.accept(commentID)
                }

                cell.onTapDeleteButton = { [weak self] commentID in
                    self?.deleteCommentIDRelay.accept(commentID)
                }
            }
            .disposed(by: disposeBag)
    }

    func bindRoute(output: CommentListViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                owner.courseFlowCoordinator?.handleCommentListRoute(route, from: owner)
            }
            .disposed(by: disposeBag)
    }

    func bindDeleteAlert(output: CommentListViewModel.Output) {
        output.showDeleteAlert
            .emit(with: self) { owner, alert in
                let alertController = UIAlertController(
                    title: alert.title,
                    message: alert.message,
                    preferredStyle: .alert
                )

                let cancelAction = UIAlertAction(
                    title: alert.cancelButtonTitle,
                    style: .cancel
                )

                let confirmAction = UIAlertAction(
                    title: alert.confirmButtonTitle,
                    style: .destructive
                ) { _ in
                    owner.confirmDeleteRelay.accept(())
                }

                [cancelAction, confirmAction].forEach {
                    alertController.addAction($0)
                }

                owner.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
    }

    func bindError(output: CommentListViewModel.Output) {
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

    func render(state: CommentListViewState) {
        rootView.titleLabel.text = state.courseTitle
        rootView.commentCountLabel.text = state.commentCountText

        rootView.emptyStateLabel.isHidden = state.isEmptyViewHidden
        rootView.commentTableView.isHidden = !state.isEmptyViewHidden

        rootView.latestSortButton.isSelected = state.selectedSortTitle == CommentSortOption.latest.title
        rootView.oldestSortButton.isSelected = state.selectedSortTitle == CommentSortOption.oldest.title

        rootView.updateSortButtonAppearance()

        if state.isLoading {
            rootView.loadingIndicatorView.startAnimating()
        } else {
            rootView.loadingIndicatorView.stopAnimating()
        }
    }
}
