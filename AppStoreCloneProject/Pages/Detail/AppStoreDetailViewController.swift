//
//  AppStoreDetailViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreDetailDisplayLogic: class {
    //func displaySomething(viewModel: AppStoreDetail.Something.ViewModel)
}

typealias AppStoreDetailPage = AppStoreDetailViewController
class AppStoreDetailViewController: RXViewController, AppStoreDetailDisplayLogic {
    var interactor: AppStoreDetailBusinessLogic?
    var router: (NSObjectProtocol & AppStoreDetailRoutingLogic & AppStoreDetailDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AppStoreDetailInteractor()
        let presenter = AppStoreDetailPresenter()
        let router = AppStoreDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    //  func doSomething() {
    //    let request = AppStoreDetail.Something.Request()
    //    interactor?.doSomething(request: request)
    //  }
    
    //  func displaySomething(viewModel: AppStoreDetail.Something.ViewModel) {
    //    //nameTextField.text = viewModel.name
    //  }
}
