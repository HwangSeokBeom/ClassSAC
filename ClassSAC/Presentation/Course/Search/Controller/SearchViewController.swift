//
//  SearchViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController {

    private let rootView = SearchRootView()
    private let viewModel: SearchViewModel
    private let thumbnailProvider: CourseThumbnailProviding
    private weak var courseFlowCoordinator: CourseFlowCoordinating?

    private let disposeBag = DisposeBag()
    private let likeButtonTapRelay = PublishRelay<String>()

    private var currentCourseCellViewModels: [CourseListCellViewModel] = []

    init(
        viewModel: SearchViewModel,
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

private extension SearchViewController {

    func bind() {
        let searchButtonClicked = rootView.searchBar.rx.searchButtonClicked
            .withLatestFrom(rootView.searchBar.rx.text.orEmpty)
            .asObservable()

        let courseItemSelected = rootView.courseCollectionView.rx
            .modelSelected(CourseListCellViewModel.self)
            .map(\.courseID)
            .asObservable()

        let input = SearchViewModel.Input(
            searchButtonClicked: searchButtonClicked,
            didTapCourseCell: courseItemSelected,
            didTapLikeButton: likeButtonTapRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindSearchBar()
        enableKeyboardDismissGesture()
        bindState(output)
        bindCourseCollectionView(output)
        bindNavigation(output)
        bindError(output)
        bindCollectionViewDelegate()
    }

    func bindSearchBar() {
        rootView.searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.rootView.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }

    func bindState(_ output: SearchViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.currentCourseCellViewModels = state.courses

                owner.rootView.emptyMessageLabel.text = state.emptyState.message
                owner.rootView.emptyMessageLabel.isHidden = state.emptyState == .none

                if state.isLoading {
                    owner.rootView.loadingIndicatorView.startAnimating()
                } else {
                    owner.rootView.loadingIndicatorView.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }

    func bindCourseCollectionView(_ output: SearchViewModel.Output) {
        output.state
            .map(\.courses)
            .drive(
                rootView.courseCollectionView.rx.items(
                    cellIdentifier: CourseListCollectionViewCell.identifier,
                    cellType: CourseListCollectionViewCell.self
                )
            ) { [weak self] _, cellViewModel, cell in
                guard let self else { return }

                cell.configure(
                    cellViewModel: cellViewModel,
                    thumbnailProvider: self.thumbnailProvider
                )

                cell.onTapLikeButton = { [weak self] in
                    self?.likeButtonTapRelay.accept(cellViewModel.courseID)
                }
            }
            .disposed(by: disposeBag)
    }

    func bindNavigation(_ output: SearchViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                owner.courseFlowCoordinator?.handle(route: route, from: owner)
            }
            .disposed(by: disposeBag)
    }

    func bindError(_ output: SearchViewModel.Output) {
        output.showError
            .emit(with: self) { owner, error in
                owner.showAlert(message: error.userMessage)
            }
            .disposed(by: disposeBag)
    }

    func bindCollectionViewDelegate() {
        rootView.courseCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInset: CGFloat = 22
        let interItemSpacing: CGFloat = 14
        let sectionWidth = collectionView.bounds.width - (horizontalInset * 2)

        let columnCount = searchColumnCount()
        let totalSpacing = interItemSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor((sectionWidth - totalSpacing) / CGFloat(columnCount))
        let itemHeight = itemWidth + searchCellExtraHeight()

        return CGSize(width: itemWidth, height: itemHeight)
    }

    private func searchColumnCount() -> Int {
        if traitCollection.userInterfaceIdiom == .pad {
            return 4
        }

        return 1
    }

    private func searchCellExtraHeight() -> CGFloat {
        if traitCollection.userInterfaceIdiom == .pad {
            return 132
        }

        return 120
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        18
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        14
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
}
