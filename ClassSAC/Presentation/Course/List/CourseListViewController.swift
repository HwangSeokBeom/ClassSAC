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

    private let disposeBag = DisposeBag()

    private let viewDidLoadRelay = PublishRelay<Void>()
    private let latestSortTapRelay = PublishRelay<Void>()
    private let originalPriceDescendingSortTapRelay = PublishRelay<Void>()
    private let likeButtonTapRelay = PublishRelay<Int>()

    private let selectedCategoryItemsRelay = BehaviorRelay<Set<CourseCategoryItem>>(value: [.all])
    private let categoryItemsRelay = BehaviorRelay<[CourseCategoryItem]>(value: [])
    private let courseCellViewModelsRelay = BehaviorRelay<[CourseListCellViewModel]>(value: [])

    init(viewModel: CourseListViewModel) {
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
        viewDidLoadRelay.accept(())
    }

    private func bind() {
        let input = CourseListViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            didTapNotificationButton: rootView.notificationButton.rx.tap.asObservable(),
            didTapProfileButton: rootView.profileButton.rx.tap.asObservable(),
            didTapCategoryItem: rootView.categoryCollectionView.rx.modelSelected(CourseCategoryItem.self).asObservable(),
            didTapLatestSortButton: latestSortTapRelay.asObservable(),
            didTapOriginalPriceDescendingSortButton: originalPriceDescendingSortTapRelay.asObservable(),
            didTapCourseCell: rootView.courseCollectionView.rx.itemSelected.map(\.item).asObservable(),
            didTapLikeButton: likeButtonTapRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.categoryItems
            .bind(to: categoryItemsRelay)
            .disposed(by: disposeBag)

        output.selectedCategoryItems
            .bind(to: selectedCategoryItemsRelay)
            .disposed(by: disposeBag)

        output.courseCellViewModels
            .bind(to: courseCellViewModelsRelay)
            .disposed(by: disposeBag)

        output.selectedSortType
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, sortType in
                owner.rootView.updateSortButtonTitle(sortType: sortType)
            }
            .disposed(by: disposeBag)

        output.courseCountText
            .bind(to: rootView.courseCountLabel.rx.text)
            .disposed(by: disposeBag)

        output.showErrorMessage
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)

        output.routeToNotifications
            .observe(on: MainScheduler.instance)
            .bind(with: self) { _, _ in
            }
            .disposed(by: disposeBag)

        output.routeToProfile
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let profileViewController = UIViewController()
                profileViewController.view.backgroundColor = AppColor.bgPrimary
                profileViewController.title = "프로필"
                owner.navigationController?.pushViewController(profileViewController, animated: true)
            }
            .disposed(by: disposeBag)

        output.routeToCourseDetail
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, courseID in
                let detailViewController = UIViewController()
                detailViewController.view.backgroundColor = AppColor.bgPrimary
                detailViewController.title = courseID
                owner.navigationController?.pushViewController(detailViewController, animated: true)
            }
            .disposed(by: disposeBag)

        rootView.sortButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentSortActionSheet()
            }
            .disposed(by: disposeBag)

        categoryItemsRelay
            .bind(to: rootView.categoryCollectionView.rx.items(
                cellIdentifier: CourseCategoryCollectionViewCell.identifier,
                cellType: CourseCategoryCollectionViewCell.self
            )) { [weak self] _, categoryItem, cell in
                guard let self else { return }

                let isSelected = self.selectedCategoryItemsRelay.value.contains(categoryItem)

                cell.configure(
                    title: categoryItem.title,
                    isSelected: isSelected
                )
            }
            .disposed(by: disposeBag)

        courseCellViewModelsRelay
            .bind(to: rootView.courseCollectionView.rx.items(
                cellIdentifier: CourseListCollectionViewCell.identifier,
                cellType: CourseListCollectionViewCell.self
            )) { [weak self] index, cellViewModel, cell in
                guard let self else { return }

                cell.configure(cellViewModel: cellViewModel)

                cell.onTapLikeButton = { [weak self] in
                    self?.likeButtonTapRelay.accept(index)
                }
            }
            .disposed(by: disposeBag)

        rootView.categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        rootView.courseCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func presentSortActionSheet() {
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
            let categoryItems = categoryItemsRelay.value
            let title = categoryItems[indexPath.item].title
            let width = (title as NSString).size(withAttributes: [.font: AppFont.caption.font]).width + 28
            return CGSize(width: width, height: 32)
        }

        let horizontalInset: CGFloat = 22
        let spacing: CGFloat = 14
        let width = (collectionView.bounds.width - (horizontalInset * 2) - spacing) / 2
        return CGSize(width: width, height: width + 94)
    }
}
