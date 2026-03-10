//
//  ProfileViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapLogoutButton: Observable<Void>
        let didConfirmLogout: Observable<Void>
    }

    struct Output {
        let state: Driver<ProfileViewState>
        let route: Signal<ProfileRoute>
        let showLogoutAlert: Signal<ProfileAlert>
        let showErrorMessage: Signal<String>
    }

    private let fetchMyProfileUseCase: FetchMyProfileUseCase
    private let logoutUseCase: LogoutUseCase

    private let disposeBag = DisposeBag()

    private let profileRelay = BehaviorRelay<UserProfile?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)

    init(
        fetchMyProfileUseCase: FetchMyProfileUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.fetchMyProfileUseCase = fetchMyProfileUseCase
        self.logoutUseCase = logoutUseCase
    }

    func transform(input: Input) -> Output {
        let routeRelay = PublishRelay<ProfileRoute>()
        let showLogoutAlertRelay = PublishRelay<ProfileAlert>()
        let showErrorMessageRelay = PublishRelay<String>()

        bindFetchProfile(
            input: input,
            showErrorMessageRelay: showErrorMessageRelay
        )

        bindShowLogoutAlert(
            input: input,
            showLogoutAlertRelay: showLogoutAlertRelay
        )

        bindLogout(
            input: input,
            routeRelay: routeRelay,
            showErrorMessageRelay: showErrorMessageRelay
        )

        return Output(
            state: makeStateDriver(),
            route: routeRelay.asSignal(),
            showLogoutAlert: showLogoutAlertRelay.asSignal(),
            showErrorMessage: showErrorMessageRelay.asSignal()
        )
    }
}

private extension ProfileViewModel {

    func bindFetchProfile(
        input: Input,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.viewDidLoad
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] _ -> Observable<UserProfile> in
                guard let self else { return .empty() }

                return self.fetchMyProfileUseCase.execute()
                    .asObservable()
                    .do(
                        onNext: { [weak self] _ in
                            self?.isLoadingRelay.accept(false)
                        },
                        onError: { [weak self] error in
                            self?.isLoadingRelay.accept(false)
                            self?.emitErrorMessage(from: error, to: showErrorMessageRelay)
                        }
                    )
                    .catch { _ in
                        .empty()
                    }
            }
            .bind(to: profileRelay)
            .disposed(by: disposeBag)
    }

    func bindShowLogoutAlert(
        input: Input,
        showLogoutAlertRelay: PublishRelay<ProfileAlert>
    ) {
        input.didTapLogoutButton
            .map { ProfileAlert.logoutConfirm }
            .bind(to: showLogoutAlertRelay)
            .disposed(by: disposeBag)
    }

    func bindLogout(
        input: Input,
        routeRelay: PublishRelay<ProfileRoute>,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.didConfirmLogout
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }

                return self.logoutUseCase.execute()
                    .andThen(Observable.just(()))
                    .do(
                        onNext: { [weak self] _ in
                            self?.isLoadingRelay.accept(false)
                        },
                        onError: { [weak self] error in
                            self?.isLoadingRelay.accept(false)
                            self?.emitErrorMessage(from: error, to: showErrorMessageRelay)
                        }
                    )
                    .catch { _ in
                        .empty()
                    }
            }
            .map { ProfileRoute.login }
            .bind(to: routeRelay)
            .disposed(by: disposeBag)
    }

    func makeStateDriver() -> Driver<ProfileViewState> {
        Observable
            .combineLatest(
                profileRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { profile, isLoading in
                guard let profile else {
                    return ProfileViewState.empty.copy(isLoading: isLoading)
                }

                return ProfileViewState(
                    nick: profile.nick,
                    email: profile.email,
                    profileImagePath: profile.profileImageURL,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorJustReturn: .empty)
    }

    func emitErrorMessage(
        from error: Error,
        to relay: PublishRelay<String>
    ) {
        let message: String

        if let profileError = error as? ProfileError {
            message = profileError.userMessage
        } else {
            message = ProfileError.unknown.userMessage
        }

        relay.accept(message)
    }
}

private extension ProfileViewState {

    func copy(isLoading: Bool) -> ProfileViewState {
        ProfileViewState(
            nick: nick,
            email: email,
            profileImagePath: profileImagePath,
            isLoading: isLoading
        )
    }
}
