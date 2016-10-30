//
//  MSRAnimationInfo.swift
//  iCampus
//
//  Created by Bill Hu on 16/10/29.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit

@objc class MSRAnimationInfo: NSObject {
    override init() {
        super.init()
    }
    init(keyboardNotification: Notification) {
        let info = keyboardNotification.userInfo! as! [String: AnyObject]
        frameBegin = info[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue
        frameEnd = info[UIKeyboardFrameEndUserInfoKey]!.cgRectValue
        duration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
        curve = UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey]!.intValue!)!
        super.init()
    }
    func animate(_ animation: @escaping (() -> Void)) {
        animate(animation, completion: nil)
    }
    func animate(_ animation: @escaping (() -> Void), completion: ((Bool) -> Void)?) {
        animate(delay: 0, options: [], animation: animation, completion: completion)
    }
    func animate(delay: TimeInterval, options: UIViewAnimationOptions, animation: @escaping (() -> Void), completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration,
                                   delay: delay,
                                   options: [UIViewAnimationOptions(rawValue: UInt(curve.rawValue)),  options],
                                   animations: animation,
                                   completion: completion)
    }
    var frameBegin: CGRect = CGRect.zero
    var frameEnd: CGRect = CGRect.zero
    var duration: TimeInterval = 0
    var curve: UIViewAnimationCurve = .linear
}
