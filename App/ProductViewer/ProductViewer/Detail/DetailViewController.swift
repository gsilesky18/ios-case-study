//
//  DetailViewController.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation
import Tempo

class DetailViewController: UIViewController {
    
    class func viewControllerFor(coordinator: TempoCoordinator) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.coordinator = coordinator
        
        return viewController
    }
    
    fileprivate var coordinator: TempoCoordinator!
    
        lazy var collectionView: UICollectionView = {
        let harmonyLayout = HarmonyLayout()
        
        harmonyLayout.collectionViewMargins = HarmonyLayoutMargins(top: .none, right: .quarter, bottom: .none, left: .quarter)
        harmonyLayout.defaultSectionMargins = HarmonyLayoutMargins(top: .none, right: .none, bottom: .none, left: .none)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: harmonyLayout)
        collectionView.backgroundColor = .targetStarkWhiteColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addAndPinSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        title = "Detail"
        
        let components: [ComponentType] = [
            ProductImageComponent(),
            ProductPriceComponent(),
            ProductDescriptionComponent(),
            ProductAddToComponent()
        ]
        
        let componentProvider = ComponentProvider(components: components, dispatcher: coordinator.dispatcher)
        let collectionViewAdapter = CollectionViewAdapter(collectionView: collectionView, componentProvider: componentProvider)
        
        coordinator.presenters = [
            SectionPresenter(adapter: collectionViewAdapter),
        ]

    }
}
