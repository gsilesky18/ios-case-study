//
//  ListCoordinator.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
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
    
    private var viewState: ListViewState {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    private func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item selected!", message: "🐶", preferredStyle: .Alert)
            alert.addAction( UIAlertAction(title: "OK", style: .Cancel, handler: nil) )
            self?.viewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updateState() {
        viewState.listItems = (1..<10).map { index in
            ListItemViewState(title: "Puppies!!!", price: "$9.99", image: UIImage(named: "\(index)"))
        }
    }
}