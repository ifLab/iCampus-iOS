//
//  ICNewsMainViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/4.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit
import HMSegmentedControl

class ICNewsMainViewController: UIViewController, UIScrollViewDelegate {
    
    let titles = ["综合新闻", "图片新闻", "人才培养", "教学科研", "文化活动", "校园人物", "交流合作", "社会服务", "媒体关注"]
    let categorys = ["zhxw", "tpxw", "rcpy", "jxky", "whhd", "xyrw", "jlhz", "shfw", "mtgz"]
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    lazy var scrollView: UIScrollView = {
        var s = UIScrollView.init()
        if PJCurrentPhone.pjCurrentPhone("iPhoneX") {
            s.frame = CGRect(x: 0, y: 130, width: self.width, height: self.height - 124)
        } else {
            s.frame = CGRect(x: 0, y: 104, width: self.width, height: self.height - 104)
        }
        s.contentSize = CGSize(width: self.width * CGFloat(self.titles.count) , height: s.frame.height)
        s.backgroundColor = .white
        s.isPagingEnabled = true
        s.showsHorizontalScrollIndicator = false
        s.delegate = self
        return s
    }()
    
    var viewConstraints = [NSLayoutConstraint]()
    var segmentTopConstraintNavHide = NSLayoutConstraint()
    var segmentTopConstraintNavUnHide = NSLayoutConstraint()
    lazy var childControllers: [ICNewsTableViewController] = {
        var c = [ICNewsTableViewController]()
        for i in 0..<self.titles.count {
            let title = self.titles[i]
            let t = ICNewsTableViewController(category: self.categorys[i], title: self.titles[i])
            t.view.frame = CGRect(x: CGFloat(i) * self.width, y: 0, width: self.width, height: self.height - 104 - 22)
            c.append(t)
        }
        return c
    }()
    
    lazy var segmentedControl: HMSegmentedControl = {
        let sc = HMSegmentedControl(sectionTitles: self.titles)!
        if PJCurrentPhone.pjCurrentPhone("iPhoneX") {
            sc.frame = CGRect(x: 0, y: 90, width: self.width, height: 40)
        } else {
            sc.frame = CGRect(x: 0, y: 64, width: self.width, height: 40)
        }
        sc.selectionStyle = .fullWidthStripe
        sc.selectionIndicatorLocation = .down
        sc.selectionIndicatorColor = UIColor.black
        sc.selectionIndicatorHeight = 2
        sc.titleTextAttributes = {[
            NSForegroundColorAttributeName : UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1),
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)
            ]}();
        sc.selectedTitleTextAttributes = {[
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)
            ]}();
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新闻"
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        for v in childControllers {
            scrollView.addSubview(v.view)
            addChildViewController(v)
        }
        segmentedControl.indexChangeBlock = {
            [weak self] index in
            if let self_ = self {
                self_.scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * self_.width, y: 0, width: self_.width, height: self_.height), animated: true)
            }
        }
        if PJUser.current() != nil {
            childControllers[0].refresh()
            childControllers[0].headerBeginRefresh()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name("UserDidLoginNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loginRefresh() {
        childControllers[0].refresh()
        childControllers[0].headerBeginRefresh()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
//MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}
