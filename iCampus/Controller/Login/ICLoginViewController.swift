//
//  ICLoginViewController.swift
//  iCampus
//
//  Created by Bill Hu on 16/10/28.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit

enum ICLoginViewControllerState: Int {
    case login
    case register
}

class ICLoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var verfyCodeView: UIView!
    @IBOutlet weak var verfyCodeField: UITextField!
    @IBOutlet weak var verfyCodeButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verfyPasswordField: UITextField!
    @IBOutlet weak var loginAndRegisterButton: UIButton!
    @IBOutlet weak var loginIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailPostionConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonPostionConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchButton: UIButton!//switch between login and register
    lazy var state: ICLoginViewControllerState = {
        return .login
    }()
    var timer: Timer?
    var verfyCodeFetchedTime: TimeInterval?
    lazy var buttonColor: UIColor = {
        UIColor(red: 26/255.0, green: 152/255.0, blue: 252/255.0, alpha: 1)
    }()
    
    @IBAction func switchStatus(_ sender: UIButton) {
        if state == .login {
            state = .register
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
                [weak self] in
                if let _self = self {
                    _self.loginAndRegisterButton.setTitle("注册", for: .normal)
                    _self.switchButton.setTitle("已有账户?立即登录", for: .normal)
                    _self.emailPostionConstraint.constant = 130
                    _self.loginButtonPostionConstraint.constant = 80
                    _self.view.setNeedsLayout()
                    _self.view.layoutIfNeeded()
                }
                }, completion: { [weak self] _ in
                    if let _self = self {
                        _self.phoneField.isHidden = false
                        _self.verfyCodeView.isHidden = false
                        _self.verfyPasswordField.isHidden = false
                        _self.forgetPasswordButton.isHidden = true
                        _self.view.setNeedsLayout()
                        _self.view.layoutIfNeeded()
                    }
            })
        } else {
            state = .login
            phoneField.isHidden = true
            verfyCodeView.isHidden = true
            verfyPasswordField.isHidden = true
            forgetPasswordButton.isHidden = false
            UIView.animate(withDuration: 0.25, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
                [weak self] in
                if let _self = self {
                    _self.loginAndRegisterButton.setTitle("登录", for: .normal)
                    _self.switchButton.setTitle("没有账户?立即注册", for: .normal)
                    _self.emailPostionConstraint.constant = 30
                    _self.loginButtonPostionConstraint.constant = 30
                    _self.view.setNeedsLayout()
                    _self.view.layoutIfNeeded()
                }
                }, completion: nil)
        }
    }
    
    @IBAction func loginOrRegister(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        messageLabel.text = ""
        loginIndicatorView.isHidden = false
        if state == .login {
            //            login
            if emailField.text?.range(of: "@") != nil {
                if (passwordField.text?.lengthOfBytes(using: String.Encoding.ascii))! >= 6 {
                    ICLoginManager.login(emailField.text,
                                         password: passwordField.text,
                                         success: {
                                            [weak self] data in
                                            if let self_ = self {
                                                let controller = ICGateViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                                controller.view.frame = UIScreen.main.bounds
                                                let navcontroller = UINavigationController(rootViewController: controller)
                                                self_.present(navcontroller, animated: true, completion: nil)
                                            }
                        },
                                         failure: {
                                            [weak self] message in
                                            if let self_ = self {
                                                self_.messageLabel.text = message
                                                self_.finishedLoginOrRegister()
                                            }
                    })
                } else {
                    messageLabel.text = "密码长度最少6个字符"
                    finishedLoginOrRegister()
                }
            } else {
                messageLabel.text = "邮箱格式错误"
                finishedLoginOrRegister()
            }
        } else {
            //register
            if (phoneField.text?.lengthOfBytes(using: String.Encoding.ascii)) == 11 {
                if emailField.text?.range(of: "@") != nil {
                    if (passwordField.text?.lengthOfBytes(using: String.Encoding.ascii))! >= 6 {
                        if passwordField.text == verfyPasswordField.text {
                            ICLoginManager.signUp(emailField.text,
                                                  password: passwordField.text,
                                                  phone: phoneField.text,
                                                  verfyCode: verfyCodeField.text, success: { [weak self] (data) in
                                                    if let self_ = self {
                                                        self_.messageLabel.text = "success"
                                                        self_.finishedLoginOrRegister()
                                                        self_.finishedLoginOrRegister()
                                                        self_.switchStatus(self_.switchButton)
                                                        self_.loginOrRegister(self_.loginAndRegisterButton)
                                                    }
                                },
                                                  failure: { [weak self] error in
                                                    if let self_ = self {
                                                        self_.messageLabel.text = error
                                                        self_.finishedLoginOrRegister()
                                                    }
                            })
                        } else {
                            messageLabel.text = "两次输入的密码不一样"
                            finishedLoginOrRegister()
                        }
                    } else {
                        messageLabel.text = "密码长度最少6个字符"
                        finishedLoginOrRegister()
                    }
                } else {
                    messageLabel.text = "邮箱格式错误"
                    finishedLoginOrRegister()
                }
            } else {
                messageLabel.text = "手机号格式错误"
                finishedLoginOrRegister()
            }
            
        }
    }
    
    func finishedLoginOrRegister() {
        loginAndRegisterButton.isEnabled = true
        loginAndRegisterButton.backgroundColor = buttonColor
        loginIndicatorView.isHidden = true
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let alertVC = UIAlertController.init(title: "忘记密码", message: nil, preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入邮箱地址"
            textField.text = self.emailField.text
        }
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { action in
            ICLoginManager.resetPassword(alertVC.textFields![0].text, success: {
                [weak self] message in
                alertVC.dismiss(animated: true, completion: nil)
                if let self_ = self {
                    self_.messageLabel.text = "一封电子邮件已发送至您的电子邮件地址"
                }
                }, failure: {
                    [weak self] message in
                    alertVC.dismiss(animated: true, completion: nil)
                    if let self_ = self {
                        self_.messageLabel.text = message
                    }
            })
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func sendVerfyCode(_ sender: UIButton) {
        if sender.isEnabled {
            sender.isEnabled = false
            verfyCodeButton.backgroundColor = .gray
            verfyCodeFetchedTime = NSDate.init().timeIntervalSince1970
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(verfyCodeFetchedTimeSet),
                                         userInfo: nil,
                                         repeats: true)
            ICLoginManager.fetchVerfyCode(phoneField.text,
                                          success: {
            },
                                          failure: {
                                            [weak self] message in
                                            if let self_ = self {
                                                self_.timer = nil
                                                self_.verfyCodeFetchedTime = nil
                                                self_.verfyCodeButton.isEnabled = true
                                                self_.verfyCodeButton.backgroundColor = self_.buttonColor
                                                self_.verfyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
                                                self_.messageLabel.text = message
                                            }
            })
            
        }
    }
    
    func verfyCodeFetchedTimeSet() {
        if let sentTime = verfyCodeFetchedTime {
            let now = NSDate.init().timeIntervalSince1970
            let secound = "\(Int(60 - now + sentTime))s"
            verfyCodeButton.setTitle(secound, for: .disabled)
            if now - sentTime > 60 {
                timer = nil
                verfyCodeFetchedTime = nil
                verfyCodeButton.isEnabled = true
                verfyCodeButton.backgroundColor = loginAndRegisterButton.backgroundColor
                verfyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
            }
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
        verfyCodeButton.backgroundColor = loginAndRegisterButton.backgroundColor
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
                    sv.contentInset.top = -info.frameEnd.height + UIScreen.main.bounds.height - (self_.state == .login ? 410 : 560)
                }
            }
        }
    }
    
    func didTouchBlankArea() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
}
