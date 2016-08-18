//
//  ListCoordinator.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            for presenter in presenters {
                presenter.present(viewState)
            }
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    private var viewState: ListViewState {
        didSet {
            for presenter in presenters {
                presenter.present(viewState)
            }
        }
    }
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
    }
    
    func updateState() {
        viewState.listItems = (1..<10).map { index in
            ListItemViewState(title: "Puppies!!!", price: "$9.99", image: UIImage(named: "\(index)"))
        }
    }
}