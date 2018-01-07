//
//  ICCASViewController.swift
//  iCampus
//
//  Created by Bill Hu on 17/6/21.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit

class ICCASViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var casBGView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func login(_ sender: UIButton) {
        CASLogin()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
    }
    
    func CASLogin() {
        PJHUD.show(withStatus: "")
        CASBistu.login(withUsername: usernameField.text,
                       password: passwordField.text) {
                        [weak self] dict, error in
                        if let self_ = self {
                            if error != nil {
                                let errStr = "输入错误"
                                PJHUD.showError(withStatus: errStr)
                            } else {
                                self_.dismiss(animated: true, completion: {
                                    NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"),object: nil)
                                })
                                PJHUD.dismiss()
                            }
                        }
        }
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
        //CAS暂不登入只允许看新闻
        NotificationCenter.default.post(name: NSNotification.Name("UserNotLoginYetNotification"),object: nil)
        dismiss(animated: true) {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didTouchBlankArea))
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTouchBlankArea))
        pan.require(toFail: tap)
        containerView.addGestureRecognizer(pan)
        containerView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        casBGView.backgroundColor = UIColor.black
        casBGView.alpha = 0.3
        
        let usernameFieldLine = UIView.init(frame: CGRect(x:0, y:39, width:usernameField.frame.size.width, height:1))
        usernameFieldLine.backgroundColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
        usernameField.addSubview(usernameFieldLine)
        usernameField.attributedPlaceholder = NSAttributedString.init(string: usernameField.placeholder!, attributes: {[NSForegroundColorAttributeName : UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)]}())
        usernameField.tintColor = UIColor.white
        usernameField.returnKeyType = .next
        usernameField.delegate = self
        usernameField.tag = 10
        
        let passwordFieldLine = UIView.init(frame: CGRect(x:0, y:39, width:usernameField.frame.size.width, height:1))
        passwordFieldLine.backgroundColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
        passwordField.addSubview(passwordFieldLine)
        passwordField.attributedPlaceholder = NSAttributedString.init(string: passwordField.placeholder!, attributes: {[NSForegroundColorAttributeName : UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)]}())
        passwordField.tintColor = UIColor.white
        passwordField.returnKeyType = .go
        passwordField.delegate = self
        passwordField.tag = 20
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameField.isFirstResponder {
            passwordField.becomeFirstResponder()
        }
        
        if textField.tag == 20 {
            CASLogin()
            passwordField.resignFirstResponder()
            usernameField.resignFirstResponder()
        }
        
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
