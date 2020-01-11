//
//  ListCoordinator.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

/*
 Coordinator for the product list
 */
class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: ListViewState {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var networkingStatusOverlayViewState: NetworkingStatusOverlayViewState{
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        for presenter in presenters {
            if presenter is SectionPresenter{
                presenter.present(viewState)
            }else if presenter is NetworkingStatusOverlayPresenter {
                presenter.present(networkingStatusOverlayViewState)
            }
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    let productLoader: ProductLoader
    var products: [Product] = [] {
        didSet{
            viewState.listItems = products.map({ product in
                ListItemViewState(title: product.title, price: product.salePrice ?? product.price, imageUrl: product.image, aisle: product.aisle.uppercased())
            })
        }
    }
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        networkingStatusOverlayViewState = NetworkingStatusOverlayViewState(requestState: .pending)
        productLoader = ProductLoader(manager: NetworkManager())
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item selected!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateState() {
        DispatchQueue.main.async { [weak self] in
            self?.networkingStatusOverlayViewState.requestState = .inProgress
            self?.productLoader.fetchProducts { [weak self] (result) in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let products):
                        self?.products = products
                        self?.networkingStatusOverlayViewState.requestState = .successful
                        break
                    case .failure(let error):
                        self?.networkingStatusOverlayViewState.requestState = .failed(error.localizedDescription)
                        break
                    }
                }
            }
        }

    }
}
