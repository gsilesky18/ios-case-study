//
//  NetworkingStatusOverlayView.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/10/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit
import Tempo

final class NetworkingStatusOverlayView: UIView {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
}

extension NetworkingStatusOverlayView: NibLoadedType {
    @nonobjc static let nibName = "NetworkingStatusOverlayView"
}
