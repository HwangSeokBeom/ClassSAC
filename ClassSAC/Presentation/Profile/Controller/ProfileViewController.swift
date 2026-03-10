//
//  ProfileViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {

    private let rootView = ProfileRootView()
    private let viewModel: ProfileViewModel
    private let thumbnailProvider: RemoteImageProviding
    private let routeHandler: (ProfileRoute) -> Void

    private let disposeBag = DisposeBag()
    private let confirmLogoutRelay = PublishRelay<Void>()

    init(
        viewModel: ProfileViewModel,
        thumbnailProvider: RemoteImageProviding,
        routeHandler: @escaping (ProfileRoute) -> Void
    ) {
        self.viewModel = viewModel
        self.thumbnailProvider = thumbnailProvider
        self.routeHandler = routeHandler
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

    deinit {
        thumbnailProvider.cancelLoad(on: rootView.profileImageView)
    }
}

private extension ProfileViewController {

    func bind() {
        let input = ProfileViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapLogoutButton: rootView.logoutButton.rx.tap.asObservable(),
            didConfirmLogout: confirmLogoutRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        bindBackButton()
        bindState(output)
        bindAlert(output)
        bindRoute(output)
        bindError(output)
    }

    func bindBackButton() {
        rootView.backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    func bindState(_ output: ProfileViewModel.Output) {
        output.state
            .drive(with: self) { owner, state in
                owner.rootView.render(state: state)
                owner.loadProfileImageIfNeeded(path: state.profileImagePath)
            }
            .disposed(by: disposeBag)
    }

    func bindAlert(_ output: ProfileViewModel.Output) {
        output.showLogoutAlert
            .emit(with: self) { owner, alert in
                owner.presentLogoutAlert(alert)
            }
            .disposed(by: disposeBag)
    }

    func bindRoute(_ output: ProfileViewModel.Output) {
        output.route
            .emit(with: self) { owner, route in
                owner.routeHandler(route)
            }
            .disposed(by: disposeBag)
    }

    func bindError(_ output: ProfileViewModel.Output) {
        output.showErrorMessage
            .emit(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }

    func presentLogoutAlert(_ alert: ProfileAlert) {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: alert.cancelTitle,
            style: .cancel
        )

        let confirmAction = UIAlertAction(
            title: alert.confirmTitle,
            style: .destructive
        ) { [weak self] _ in
            self?.confirmLogoutRelay.accept(())
        }

        [
            cancelAction,
            confirmAction
        ].forEach { alertController.addAction($0) }

        present(alertController, animated: true)
    }

    func loadProfileImageIfNeeded(path: String?) {
        thumbnailProvider.cancelLoad(on: rootView.profileImageView)

        guard let path, !path.isEmpty else {
            rootView.updateProfileImage(AppIcon.person.image)
            return
        }

        thumbnailProvider.loadThumbnail(
            on: rootView.profileImageView,
            path: path
        )
    }
}
