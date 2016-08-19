//
//  Dispatch.swift
//  HarmonyKit
//
//  Created by Adam May on 3/16/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

public func after(delay: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue(), _ body: () -> Void) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, queue, body)
}
