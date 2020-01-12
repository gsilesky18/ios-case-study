//
//  DetailCoordinator.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation
import Tempo

/*
 Coordinator for the product detail
 */
class DetailCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: DetailViewState {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: DetailViewController = {
        return DetailViewController.viewControllerFor(coordinator: self)
    }()
    
    required init(product: Product) {
        let image = ProductImageViewState(imageUrl: URL(string: product.image))
        let price = ProductPriceViewState(price: product.salePrice ?? product.price)
        let description = ProductDescriptionViewState(description: product.description)
        let addTo = ProductAddToViewState()
        viewState = DetailViewState(image: image, price: price, description: description, addTo: addTo)
        registerListeners()
    }
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(AddToCartPressed.self) { [weak self] event in
            self?.displayAlertView(message: "This item has been added to your cart.")
        }
        
        dispatcher.addObserver(AddToListPressed.self) { [weak self] event in
            self?.displayAlertView(message: "This item has been added to your list.")
        }
    }
    
    fileprivate func displayAlertView(message: String){
        let alert = UIAlertController(title: "Thank You!", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
}
