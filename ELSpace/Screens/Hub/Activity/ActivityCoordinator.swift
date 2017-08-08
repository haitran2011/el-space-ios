import UIKit
import RxSwift

class ActivityCoordinator: Coordinator {

    init(viewController: ActivityViewController,
         viewModel: ActivityViewModelProtocol) {
        self.viewController = viewController
        self.viewModel = viewModel
        setupBindings()
    }

    // MARK: - Coordinator

    var initialViewController: UIViewController {
        return viewController
    }

    // MARK: - Private

    private let viewController: ActivityViewController
    private let viewModel: ActivityViewModelProtocol

    // MARK: - Bindings

    private func setupBindings() {
        viewController.rx.viewDidAppear
            .subscribe(onNext: { [weak self] in
                self?.viewModel.getData()
            }).disposed(by: disposeBag)

        viewModel.dataSource
            .subscribe(onNext: { [weak self] viewModels in
                self?.viewController.reportsTableViewController.viewModels = viewModels
            }).disposed(by: disposeBag)

        viewModel.isLoading
            .bind(to: viewController.loadingIndicator.rx.isLoading)
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()

}
