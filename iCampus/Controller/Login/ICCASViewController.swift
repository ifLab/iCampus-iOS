//
//  ICCASViewController.swift
//  iCampus
//
//  Created by Bill Hu on 17/6/21.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit
import SVProgressHUD

class ICCASViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    lazy var buttonColor: UIColor = {
        UIColor(red: 26/255.0, green: 152/255.0, blue: 252/255.0, alpha: 1)
    }()
    
    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        messageLabel.text = ""
        loginIndicatorView.isHidden = false
        CASBistu.login(withUsername: usernameField.text,
                       password: passwordField.text) {
                        [weak self] dict, error in
                        if let self_ = self {
                            if error != nil {
                                self_.messageLabel.text = error
                                self_.finishedLogin()
                            } else {
                                self_.messageLabel.text = "认证成功!"
                                self_.dismiss(animated: true, completion: nil)
                            }
                        }
        }
    }
    
    func finishedLogin() {
        loginButton.isEnabled = true
        loginButton.backgroundColor = buttonColor
        loginIndicatorView.isHidden = true
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let url = URL(string: "http://info.bistu.edu.cn/auth/find.html")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func notLoginYet(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didTouchBlankArea))
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTouchBlankArea))
        pan.require(toFail: tap)
        containerView.addGestureRecognizer(pan)
        containerView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardWillChangeFrame(notification: Notification) {
        let info = MSRAnimationInfo(keyboardNotification: notification)
        info.animate() {
            [weak self] in
            if let self_ = self {
                let sv = self_.scrollView!
                if info.frameEnd.minY == UIScreen.main.bounds.height {
                    sv.contentInset.top = 0
                } else {
                    sv.contentInset.top = -info.frameEnd.height + UIScreen.main.bounds.height - 410
                }
            }
        }
    }
    
    func didTouchBlankArea() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil);
    }
    
}
