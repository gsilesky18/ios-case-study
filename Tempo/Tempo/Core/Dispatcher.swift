//
//  Dispatcher.swift
//  HarmonyKit
//
//  Created by Adam May on 11/10/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public final class Dispatcher {
    private var observers = [String: NSHashTable]()

    // MARK: Init

    public init() {}

    // MARK: Subscribe

    public func addObserver<T: EventType>(eventType: T.Type, onEvent: (T) -> ()) {
        let observer = Observer<T>(notify: onEvent)

        if let eventSpecificObservers = observers[eventType.key] {
            eventSpecificObservers.addObject(observer)
            return
        }
        observers[eventType.key] = NSHashTable()
        observers[eventType.key]?.addObject(observer)
    }

    // MARK: Notification

    public func triggerEvent<T: EventType>(event: T) {
        observers[event.dynamicType.key]?.forEachObserver({ (observer: Observer<T>) in
            observer.notify(event)
        })
    }
}

// MARK: Observer Protocols

private final class Observer<T> {
    init(notify: (T) -> ()) {
        self.notify = notify
    }
    var notify: (T) -> ()
}

/**
 *  Private extension created to eliminate casting throughout this class.
 */
private extension NSHashTable {
    func forEachObserver<T>(action: (T) -> ()) {
        self.allObjects.forEach { observer in
            if let castedObserver = observer as? T {
                action(castedObserver)
            }
        }
    }
}
