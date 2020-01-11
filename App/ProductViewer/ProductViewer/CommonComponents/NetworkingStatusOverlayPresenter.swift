//
//  NetworkingStatusOverlayPresenter.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

class NetworkingStatusOverlayPresenter: TempoPresenter {
    func present(_ viewState: TempoViewState) {
        guard let viewState = viewState as? NetworkingStatusOverlayViewState else {
            networkingStatusOverlayView.isHidden = true
            return
        }
        
        switch viewState.requestState {
        case .pending:
            networkingStatusOverlayView.isHidden = true
            break
        case .inProgress:
            networkingStatusOverlayView.isHidden = false
            networkingStatusOverlayView.activityIndicatorView.isHidden = false
            networkingStatusOverlayView.activityIndicatorView.startAnimating()
            networkingStatusOverlayView.errorMessageLabel.isHidden = true
            break
        case .successful:
            networkingStatusOverlayView.isHidden = true
            break
        case .failed(let error):
            networkingStatusOverlayView.isHidden = false
            networkingStatusOverlayView.activityIndicatorView.isHidden = true
            networkingStatusOverlayView.activityIndicatorView.stopAnimating()
            networkingStatusOverlayView.errorMessageLabel.text = error
            networkingStatusOverlayView.errorMessageLabel.isHidden = false
            break
        }

    }

    let networkingStatusOverlayView: NetworkingStatusOverlayView

    init(networkingStatusOverlayView: NetworkingStatusOverlayView) {
        self.networkingStatusOverlayView = networkingStatusOverlayView
    }
}
