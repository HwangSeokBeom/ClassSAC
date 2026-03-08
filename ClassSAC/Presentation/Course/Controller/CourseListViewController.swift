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
    private let thumbnailProvider: CourseThumbnailProviding

    private let disposeBag = DisposeBag()

    private let latestSortTapRelay = PublishRelay<Void>()
    private let originalPriceDescendingSortTapRelay = PublishRelay<Void>()
    private let likeButtonTapRelay = PublishRelay<String>()

    private var currentCategoryCellViewModels: [CourseCategoryCellViewModel] = []
    private var currentCourseCellViewModels: [CourseListCellViewModel] = []

    init(
        viewModel: CourseListViewModel,
        thumbnailProvider: CourseThumbnailProviding
    ) {
        self.viewModel = viewModel
        self.thumbnailProvider = thumbnailProvider
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        let categoryItemSelected = rootView.categoryCollectionView.rx
            .modelSelected(CourseCategoryCellViewModel.self)
            .map(\.item)
            .asObservable()

        let courseItemSelected = rootView.courseCollectionView.rx
            .modelSelected(CourseListCellViewModel.self)
            .map(\.courseID)
            .asObservable()

        let input = CourseListViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapNotificationButton: rootView.notificationButton.rx.tap.asObservable(),
            didTapProfileButton: rootView.profileButton.rx.tap.asObservable(),
            didTapCategoryItem: categoryItemSelected,
            didTapLatestSortButton: latestSortTapRelay.asObservable(),
            didTapOriginalPriceDescendingSortButton: originalPriceDescendingSortTapRelay.asObservable(),
            didTapCourseCell: courseItemSelected,
            didTapLikeButton: likeButtonTapRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindState(output)
        bindCategoryCollectionView(output)
        bindCourseCollectionView(output)
        bindNavigation(output)
        bindError(output)
        bindSortAction()
        bindCollectionViewDelegate()
    }
}

private extension CourseListViewController {

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
                switch route {
                case .notifications:
                    break

                case .profile:
                    let profileViewController = UIViewController()
                    profileViewController.view.backgroundColor = AppColor.bgPrimary
                    profileViewController.title = "프로필"
                    owner.navigationController?.pushViewController(
                        profileViewController,
                        animated: true
                    )

                case .courseDetail(let courseID):
                    let detailViewController = UIViewController()
                    detailViewController.view.backgroundColor = AppColor.bgPrimary
                    detailViewController.title = courseID
                    owner.navigationController?.pushViewController(
                        detailViewController,
                        animated: true
                    )
                }
            }
            .disposed(by: disposeBag)
    }

    func bindError(_ output: CourseListViewModel.Output) {
        output.showErrorMessage
            .emit(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }

    func bindSortAction() {
        rootView.sortButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentSortActionSheet()
            }
            .disposed(by: disposeBag)
    }

    func bindCollectionViewDelegate() {
        rootView.categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        rootView.courseCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func presentSortActionSheet() {
        let alertController = UIAlertController(
            title: "정렬",
            message: nil,
            preferredStyle: .actionSheet
        )

        let latestAction = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.latestSortTapRelay.accept(())
        }

        let originalPriceDescendingAction = UIAlertAction(title: "금액 높은 순", style: .default) { [weak self] _ in
            self?.originalPriceDescendingSortTapRelay.accept(())
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        [
            latestAction,
            originalPriceDescendingAction,
            cancelAction
        ].forEach { alertController.addAction($0) }

        present(alertController, animated: true)
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
        let spacing: CGFloat = 14
        let width = (collectionView.bounds.width - (horizontalInset * 2) - spacing) / 2

        return CGSize(width: width, height: width + 120)
    }
}
