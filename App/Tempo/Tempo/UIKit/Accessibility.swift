//
//  Accessibility.swift
//  HarmonyKit
//
//  Created by Adam May on 3/16/16.
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

@objc public class Accessibility : NSObject {
    public static func announce(announcement: String) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, announcement)
    }

    public static func announce(announcement: String, afterDelay delay: NSTimeInterval) {
        after(delay) {
            announce(announcement)
        }
    }
    
    /**
     *  If you add/remove elements from the screen and don't want to give them focus, posting a layout changed notification will make them discoverable/undiscoverable for accessibility.
     *
     *  - Parameter announcement: An optional announcement to coincide with the layout change.
     */
    public static func postLayoutChanged(announcement: String? = nil) {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, announcement);
    }

    public static func announceScreenChanged(andFocusView view: UIView) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, view)
    }

    public static func announceScreenChanged(andSpeakAnnouncement announcement: String) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, announcement)
    }
    
    public static func announceScreenChanged(andSpeakAnnouncement announcement: String, afterDelay delay: NSTimeInterval) {
        after(delay) {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, announcement)
        }
    }
}

public extension UIView {
    func focusAccessibility() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
    }

    func focusAccessibility(afterDelay delay: NSTimeInterval) {
        after(delay) {
            self.focusAccessibility()
        }
    }
}
