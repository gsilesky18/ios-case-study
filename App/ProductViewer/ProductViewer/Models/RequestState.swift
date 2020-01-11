//
//  RequestState.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

enum RequestState {
    case pending
    case inProgress
    case successful
    case failed(String)
}
