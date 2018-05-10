//
//  KeyboardNotification.swift
//  ScrollViewExample
//
//  Created by Daniel Botka on 2018. 05. 10..
//  Copyright © 2018. Daniel Botka. All rights reserved.
//

import UIKit

protocol KeyboardNotificationProtocol {
  func keyboardChangedDelta(inView view: UIView) -> CGFloat
  func keyboardYPosition(inView view: UIView) -> CGFloat
  var keyboardAnimationCurve: UIViewAnimationOptions { get }
  var animationDuration: Double { get }
}

/// Wrapper for the NSNotification userInfo values associated with a keyboard notification.
///
/// It provides properties that retrieve userInfo dictionary values with these keys:
///
/// - UIKeyboardFrameBeginUserInfoKey
/// - UIKeyboardFrameEndUserInfoKey
/// - UIKeyboardAnimationDurationUserInfoKey
/// - UIKeyboardAnimationCurveUserInfoKey

public struct KeyboardNotification: KeyboardNotificationProtocol {
  
  let notification: NSNotification
  let userInfo: NSDictionary
  
  /// Initializer
  ///
  /// :param: notification Keyboard-related notification
  init(_ notification: NSNotification) {
    self.notification = notification
    if let userInfo = notification.userInfo {
      self.userInfo = userInfo as NSDictionary
    } else {
      self.userInfo = NSDictionary()
    }
  }
  
  /// Start frame of the keyboard in screen coordinates
  fileprivate var screenFrameBegin: CGRect {
    if let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
      return value.cgRectValue
    } else {
      return CGRect.zero
    }
  }
  
  /// End frame of the keyboard in screen coordinates
  fileprivate var screenFrameEnd: CGRect {
    if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      return value.cgRectValue
    } else {
      return CGRect.zero
    }
  }
  
  /// Keyboard animation curve
  ///
  /// Note that the value returned by this method may not correspond to a
  /// UIViewAnimationCurve enum value.  For example, in iOS 7 and iOS 8,
  /// this returns the value 7.
  fileprivate var animationCurve: Int {
    if let number = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
      return number.intValue
    }
    return UIViewAnimationCurve.easeInOut.rawValue
  }
  
  /// Start frame of the keyboard in coordinates of specified view
  ///
  /// :param: view UIView to whose coordinate system the frame will be converted
  /// :returns: frame rectangle in view's coordinate system
  fileprivate func frameBeginForView(view: UIView) -> CGRect {
    return view.convert(screenFrameBegin, from: view.window)
  }
  
  /// End frame of the keyboard in coordinates of specified view
  ///
  /// :param: view UIView to whose coordinate system the frame will be converted
  /// :returns: frame rectangle in view's coordinate system
  fileprivate func frameEndForView(view: UIView) -> CGRect {
    return view.convert(screenFrameEnd, from: view.window)
  }
}

// MARK: KeyboardNotification protocol impl
extension KeyboardNotification {
  
  func keyboardChangedDelta(inView view: UIView) -> CGFloat {
    // Get the keyboard frame inside the view
    let frameBegin = frameBeginForView(view: view)
    let frameEnd = frameEndForView(view: view)
    
    // Get the intersections with the views bounds
    let intersectionBegin = view.bounds.intersection(frameBegin)
    let intersectionEnd = view.bounds.intersection(frameEnd)
    
    if intersectionBegin == intersectionEnd { return 0 }
    
    // The height difference of the end and beginning intersections gives the delta
    return intersectionEnd.height - intersectionBegin.height
  }
  
  func keyboardYPosition(inView view: UIView) -> CGFloat {
    return view.bounds.intersection(frameEndForView(view: view)).height
  }
  
  var keyboardAnimationCurve: UIViewAnimationOptions {
    return UIViewAnimationOptions(rawValue: UInt(animationCurve) << 16)
  }
  
  /// Keyboard animation duration
  var animationDuration: Double {
    if let number = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
      return number.doubleValue
    } else {
      return 0.25
    }
  }
}
