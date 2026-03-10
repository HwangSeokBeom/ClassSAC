//
//  CourseDetailViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CourseDetailViewController: UIViewController {

    private let rootView = CourseDetailRootView()
    private let viewModel: CourseDetailViewModel
    private let thumbnailProvider: RemoteImageProviding
    private weak var courseFlowCoordinator: CourseFlowCoordinating?

    private let disposeBag = DisposeBag()

    init(
        viewModel: CourseDetailViewModel,
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

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

private extension CourseDetailViewController {

    func bind() {
        let input = CourseDetailViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapLikeButton: rootView.likeButton.rx.tap.asObservable(),
            didTapMoreCommentsButton: rootView.moreCommentsButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindImageCollectionView(output: output)
        bindState(output: output)
        bindToast(output)
        bindRoute(output: output)
        bindError(output: output)
        bindAction()
        bindCollectionViewDelegate()
    }

    func bindImageCollectionView(output: CourseDetailViewModel.Output) {
        output.state
            .map(\.imageURLs)
            .drive(with: self) { owner, imageURLs in
                owner.rootView.imagePageControl.numberOfPages = imageURLs.count
                owner.rootView.imagePageControl.currentPage = 0
            }
            .disposed(by: disposeBag)

        output.state
            .map(\.imageURLs)
            .drive(
                rootView.imageCollectionView.rx.items(
                    cellIdentifier: CourseDetailImageCollectionViewCell.identifier,
                    cellType: CourseDetailImageCollectionViewCell.self
                )
            ) { [weak self] _, imageURL, cell in
                guard let self else { return }
                cell.configure(
                    imagePath: imageURL,
                    thumbnailProvider: self.thumbnailProvider
                )
            }
            .disposed(by: disposeBag)

        rootView.imageCollectionView.rx.contentOffset
            .map { [weak self] contentOffset -> Int in
                guard let self else { return 0 }

                let width = self.rootView.imageCollectionView.bounds.width
                guard width > 0 else { return 0 }

                let page = Int(round(contentOffset.x / width))
                let maxPage = max(0, self.rootView.imagePageControl.numberOfPages - 1)

                return max(0, min(page, maxPage))
            }
            .distinctUntilChanged()
            .bind(to: rootView.imagePageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }

    func bindState(output: CourseDetailViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.render(state: state)
            }
            .disposed(by: disposeBag)
    }

    func bindRoute(output: CourseDetailViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                owner.courseFlowCoordinator?.handle(route: route, from: owner)
            }
            .disposed(by: disposeBag)
    }
    
    func bindToast(_ output: CourseDetailViewModel.Output) {
        output.showToastMessage
            .emit(with: self) { owner, message in
                owner.view.showToast(message)
            }
            .disposed(by: disposeBag)
    }

    func bindError(output: CourseDetailViewModel.Output) {
        output.showError
            .emit(with: self) { owner, error in
                owner.showAlert(message: error.userMessage)
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

    func bindCollectionViewDelegate() {
        rootView.imageCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func render(state: CourseDetailViewState) {
        rootView.categoryTagLabel.text = state.categoryTitle
        rootView.titleLabel.text = state.title
        rootView.introductionLabel.text = state.descriptionText

        updateLikeButton(isLiked: state.isLiked)

        rootView.durationInfoView.updateValue(state.durationText)
        rootView.locationInfoView.updateValue(state.locationText)
        rootView.capacityInfoView.updateValue(state.capacityText)

        renderPrice(state: state)
        renderCreator(state: state)
        renderComments(state: state)
        renderLoading(isLoading: state.isLoading)
    }

    func renderPrice(state: CourseDetailViewState) {
        if state.isFree {
            rootView.originalPriceLabel.isHidden = true
            rootView.discountPercentLabel.isHidden = true
            rootView.salePriceLabel.text = "무료"
            rootView.salePriceLabel.textColor = AppColor.accentPrimary
            return
        }

        rootView.originalPriceLabel.isHidden = !state.shouldShowOriginalPrice
        rootView.discountPercentLabel.isHidden = !state.shouldShowDiscountPercent

        if let originalPriceText = state.originalPriceText, state.shouldShowOriginalPrice {
            rootView.originalPriceLabel.attributedText = NSAttributedString(
                string: originalPriceText,
                attributes: [
                    .foregroundColor: AppColor.textTertiary,
                    .font: AppFont.body.font,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
        } else {
            rootView.originalPriceLabel.attributedText = nil
        }

        rootView.salePriceLabel.text = state.salePriceText
        rootView.salePriceLabel.textColor = AppColor.textPrimary
        rootView.discountPercentLabel.text = state.discountPercentText
    }

    func renderCreator(state: CourseDetailViewState) {
        rootView.creatorNameLabel.text = state.creatorNick

        thumbnailProvider.loadThumbnail(
            on: rootView.creatorProfileImageView,
            path: state.creatorProfileImagePath
        )
    }

    func renderComments(state: CourseDetailViewState) {
        rootView.communityCountLabel.text = state.commentCountText
        rootView.moreCommentsButton.isEnabled = state.isMoreCommentsButtonEnabled
        rootView.moreCommentsButton.alpha = state.isMoreCommentsButtonEnabled ? 1.0 : 0.4

        let previewCellViewModels = state.commentPreviewCellViewModels

        if previewCellViewModels.indices.contains(0) {
            rootView.firstCommentPreviewView.isHidden = false
            configureCommentPreviewView(
                rootView.firstCommentPreviewView,
                viewModel: previewCellViewModels[0]
            )
        } else {
            rootView.firstCommentPreviewView.isHidden = true
        }

        if previewCellViewModels.indices.contains(1) {
            rootView.secondCommentPreviewView.isHidden = false
            configureCommentPreviewView(
                rootView.secondCommentPreviewView,
                viewModel: previewCellViewModels[1]
            )
        } else {
            rootView.secondCommentPreviewView.isHidden = true
        }
    }

    func renderLoading(isLoading: Bool) {
        if isLoading {
            rootView.loadingIndicatorView.startAnimating()
        } else {
            rootView.loadingIndicatorView.stopAnimating()
        }
    }

    func updateLikeButton(isLiked: Bool) {
        let likeImage = isLiked ? AppIcon.heartFill.image : AppIcon.heart.image
        rootView.likeButton.setImage(likeImage, for: .normal)
    }

    func configureCommentPreviewView(
        _ previewView: CourseCommentPreviewView,
        viewModel: CourseCommentPreviewCellViewModel
    ) {
        previewView.writerNameLabel.text = viewModel.writerNick
        previewView.createdAtLabel.text = viewModel.createdAtText
        previewView.contentLabel.text = viewModel.contentText

        thumbnailProvider.loadThumbnail(
            on: previewView.profileImageView,
            path: viewModel.profileImagePath
        )
    }
}

extension CourseDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == rootView.imageCollectionView else { return }

        let width = scrollView.bounds.width
        guard width > 0 else { return }

        let page = Int(round(scrollView.contentOffset.x / width))
        rootView.imagePageControl.currentPage = page
    }
}
