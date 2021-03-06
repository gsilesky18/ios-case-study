//
//  ListViewController.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit
import Tempo

class ListViewController: UIViewController {
    
    class func viewControllerFor(coordinator: TempoCoordinator) -> ListViewController {
        let viewController = ListViewController()
        viewController.coordinator = coordinator
        
        return viewController
    }
    
    fileprivate var coordinator: TempoCoordinator!
    
    lazy var collectionView: UICollectionView = {
        let harmonyLayout = HarmonyLayout()
        
        harmonyLayout.collectionViewMargins = HarmonyLayoutMargins(top: .none, right: .quarter, bottom: .none, left: .quarter)
        harmonyLayout.defaultSectionMargins = HarmonyLayoutMargins(top: .quarter, right: .none, bottom: .half, left: .none)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: harmonyLayout)
        collectionView.backgroundColor = .targetStarkWhiteColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    lazy var networkingStatusOverlayView: NetworkingStatusOverlayView = {
        let view = NetworkingStatusOverlayView.loadFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addAndPinSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        view.addAndPinSubview(networkingStatusOverlayView)
        
        title = "Deals"
        
        let components: [ComponentType] = [
            ProductListComponent()
        ]
        let componentProvider = ComponentProvider(components: components, dispatcher: coordinator.dispatcher)
        let collectionViewAdapter = CollectionViewAdapter(collectionView: collectionView, componentProvider: componentProvider)

        coordinator.presenters = [
            SectionPresenter(adapter: collectionViewAdapter),
            NetworkingStatusOverlayPresenter(networkingStatusOverlayView: networkingStatusOverlayView)
        ]

        //Hide title on back button when navigating to the detail view
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}

