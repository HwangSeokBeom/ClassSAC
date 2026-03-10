//
//  CourseListViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CourseListViewController: UIViewController {

    private let rootView = CourseListRootView()
    private let viewModel: CourseListViewModel
    private let thumbnailProvider: RemoteImageProviding
    private weak var courseFlowCoordinator: CourseFlowCoordinating?

    private let disposeBag = DisposeBag()

    private let sortSelectionRelay = PublishRelay<CourseSortType>()
    private let likeButtonTapRelay = PublishRelay<String>()

    private var currentCategoryCellViewModels: [CourseCategoryCellViewModel] = []
    private var currentCourseCellViewModels: [CourseListCellViewModel] = []

    init(
        viewModel: CourseListViewModel,
        thumbnailProvider: RemoteImageProviding,
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

    private func bind() {
        configureSortMenu()

        let categoryItemSelected = rootView.categoryCollectionView.rx
            .modelSelected(CourseCategoryCellViewModel.self)
            .map(\.item)
            .asObservable()

        let courseItemSelected = rootView.courseCollectionView.rx
            .modelSelected(CourseListCellViewModel.self)
            .map(\.courseID)
            .asObservable()

        let latestSortSelected = sortSelectionRelay
            .filter { $0 == .latest }
            .map { _ in () }
            .asObservable()

        let originalPriceDescendingSortSelected = sortSelectionRelay
            .filter { $0 == .originalPriceDescending }
            .map { _ in () }
            .asObservable()

        let input = CourseListViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapNotificationButton: rootView.notificationButton.rx.tap.asObservable(),
            didTapProfileButton: rootView.profileButton.rx.tap.asObservable(),
            didTapCategoryItem: categoryItemSelected,
            didTapLatestSortButton: latestSortSelected,
            didTapOriginalPriceDescendingSortButton: originalPriceDescendingSortSelected,
            didTapCourseCell: courseItemSelected,
            didTapLikeButton: likeButtonTapRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindState(output)
        bindToast(output)
        bindCategoryCollectionView(output)
        bindCourseCollectionView(output)
        bindNavigation(output)
        bindError(output)
        bindCollectionViewDelegate()
    }
}

private extension CourseListViewController {

    func configureSortMenu() {
        let latestAction = UIAction(title: "최신순") { [weak self] _ in
            self?.sortSelectionRelay.accept(.latest)
        }

        let originalPriceDescendingAction = UIAction(title: "금액 높은 순") { [weak self] _ in
            self?.sortSelectionRelay.accept(.originalPriceDescending)
        }

        rootView.sortButton.configureMenu(actions: [
            latestAction,
            originalPriceDescendingAction
        ])
    }

    func bindState(_ output: CourseListViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.currentCategoryCellViewModels = state.categories
                owner.currentCourseCellViewModels = state.courses
                owner.rootView.courseCountLabel.text = state.courseCountText
                owner.rootView.updateSortButtonTitle(sortType: state.selectedSortType)
            }
            .disposed(by: disposeBag)
    }
    
    func bindToast(_ output: CourseListViewModel.Output) {
        output.showToastMessage
            .emit(with: self) { owner, message in
                owner.view.showToast(message)
            }
            .disposed(by: disposeBag)
    }

    func bindCategoryCollectionView(_ output: CourseListViewModel.Output) {
        output.state
            .map(\.categories)
            .drive(
                rootView.categoryCollectionView.rx.items(
                    cellIdentifier: CourseCategoryCollectionViewCell.identifier,
                    cellType: CourseCategoryCollectionViewCell.self
                )
            ) { _, cellViewModel, cell in
                cell.configure(
                    title: cellViewModel.title,
                    isSelected: cellViewModel.isSelected
                )
            }
            .disposed(by: disposeBag)
    }

    func bindCourseCollectionView(_ output: CourseListViewModel.Output) {
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

    func bindNavigation(_ output: CourseListViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                owner.courseFlowCoordinator?.handle(route: route, from: owner)
            }
            .disposed(by: disposeBag)
    }

    func bindError(_ output: CourseListViewModel.Output) {
        output.showError
            .emit(with: self) { owner, error in
                owner.showAlert(message: error.userMessage)
            }
            .disposed(by: disposeBag)
    }

    func bindCollectionViewDelegate() {
        rootView.categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        rootView.courseCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension CourseListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == rootView.categoryCollectionView {
            guard currentCategoryCellViewModels.indices.contains(indexPath.item) else {
                return .zero
            }

            let title = currentCategoryCellViewModels[indexPath.item].title
            let width = (title as NSString).size(
                withAttributes: [.font: AppFont.caption.font]
            ).width + 28

            return CGSize(width: width, height: 32)
        }

        let horizontalInset: CGFloat = 22
        let interItemSpacing: CGFloat = 14
        let sectionWidth = collectionView.bounds.width - (horizontalInset * 2)

        let columnCount = courseColumnCount()
        let totalSpacing = interItemSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor((sectionWidth - totalSpacing) / CGFloat(columnCount))
        let itemHeight = itemWidth + courseCellExtraHeight()

        return CGSize(width: itemWidth, height: itemHeight)
    }

    private func courseColumnCount() -> Int {
        if traitCollection.userInterfaceIdiom == .pad,
           view.bounds.height >= view.bounds.width {
            return 3
        }

        return 2
    }

    private func courseCellExtraHeight() -> CGFloat {
        if traitCollection.userInterfaceIdiom == .pad,
           view.bounds.height >= view.bounds.width {
            return 132
        }

        return 120
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        if collectionView == rootView.categoryCollectionView {
            return 8
        }

        return 18
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        if collectionView == rootView.categoryCollectionView {
            return 8
        }

        return 14
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if collectionView == rootView.categoryCollectionView {
            return .zero
        }

        return UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
}
