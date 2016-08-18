//
//  ListViewController.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit
import Tempo

class ListViewController: UIViewController {
    
    class func viewControllerFor(coordinator coordinator: TempoCoordinator) -> ListViewController {
        let viewController = ListViewController()
        viewController.coordinator = coordinator
        
        return viewController
    }
    
    private var coordinator: TempoCoordinator!
    
    lazy var collectionView: UICollectionView = {
        let harmonyLayout = HarmonyLayout()
        
        harmonyLayout.collectionViewMargins = HarmonyLayoutMargins(top: .Narrow, right: .None, bottom: .Narrow, left: .None)
        harmonyLayout.defaultSectionMargins = HarmonyLayoutMargins(top: .Narrow, right: .None, bottom: .None, left: .None)
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: harmonyLayout)
        collectionView.backgroundColor = .targetFadeAwayGrayColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addAndPinSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        title = "checkout"
        
        let components: [ComponentType] = [
            ProductListComponent()
        ]
        
        let componentProvider = ComponentProvider(components: components, dispatcher: coordinator.dispatcher)
        let collectionViewAdapter = CollectionViewAdapter(collectionView: collectionView, componentProvider: componentProvider)
        
        coordinator.presenters = [
            SectionPresenter(adapter: collectionViewAdapter),
        ]

    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
}

