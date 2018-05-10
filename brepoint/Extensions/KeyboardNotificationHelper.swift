//
//  KeyboardNotificationHelper.swift
//  ScrollViewExample
//
//  Created by Daniel Botka on 2018. 05. 10..
//  Copyright © 2018. Daniel Botka. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol KeyboardChangedObserver : class {
  func keyboardFrameChanged(keyboardNotification: KeyboardNotificationProtocol)
}

protocol KeyboardNotificationManagerProtocol {
  func add(subscriber: KeyboardChangedObserver)
  func remove(subscriber: KeyboardChangedObserver)
}

// MARK: - Manager
final class KeyboardNotificationManager: KeyboardNotificationManagerProtocol {
  
  struct Constants {
    static let logTag = "KeyboardNotificationHelper"
  }
  
  fileprivate var subscribers: [WeakReferenceContainer] = []
  
  init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardFrameWillChange(notification:)),
                                           name: Notification.Name.UIKeyboardWillChangeFrame,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default
      .removeObserver(
        self,
        name: Notification.Name.UIKeyboardWillChangeFrame,
        object: nil)
  }
  
  @objc func keyboardFrameWillChange(notification: NSNotification) {
    let keyboradNotification = KeyboardNotification(notification)
    
    subscribers.forEach({ $0.object?.keyboardFrameChanged(keyboardNotification: keyboradNotification) })
  }
}

// MARK: - Subscriber handling
extension KeyboardNotificationManager {
  
  func add(subscriber: KeyboardChangedObserver) {
    subscribers.append(WeakReferenceContainer(object: subscriber))
  }
  
  func remove(subscriber: KeyboardChangedObserver) {
    subscribers = subscribers.filter { return $0.object !== subscriber }
  }
}

private class WeakReferenceContainer {
  weak var object: KeyboardChangedObserver?
  init(object: KeyboardChangedObserver) {
    self.object = object
  }
}
