//
//  ICNewsMainViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/4.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit
import HMSegmentedControl

class ICNewsMainViewController: UIViewController, UIScrollViewDelegate, ICNewsParentViewController {
    
    let titles = ["综合新闻", "图片新闻", "人才培养", "教学科研", "文化活动", "校园人物", "交流合作", "社会服务", "媒体关注"]
    let categorys = ["zhxw", "tpxw", "rcpy", "jxky", "whhd", "xyrw", "jlhz", "shfw", "mtgz"]
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: 104, width: self.width, height: self.height - 104))
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
    lazy var childControllers: [UIViewController] = {
        var c = [UIViewController]()
        for i in 0..<self.titles.count {
            let title = self.titles[i]
            let t = ICNewsTableViewController(category: self.categorys[i], title: self.titles[i])
            t.view.frame = CGRect(x: CGFloat(i) * self.width, y: 0, width: self.width, height: self.height - 104)
            let random = CGFloat(Double(Int(arc4random()) % 255) / 255.0)
            c.append(t)
        }
        return c
    }()
    lazy var segmentedControl: HMSegmentedControl = {
        let sc = HMSegmentedControl(sectionTitles: self.titles)!
        sc.frame = CGRect(x: 0, y: 64, width: self.width, height: 40)
        sc.selectionStyle = .fullWidthStripe
        sc.selectionIndicatorLocation = .down
        sc.selectionIndicatorColor = .orange
        sc.selectionIndicatorHeight = 3
        sc.titleFormatter =  {
            (_, title, _, _) -> NSAttributedString? in
            let attr = NSAttributedString(string: title!, attributes: [NSForegroundColorAttributeName: UIColor.red])
            return attr
        }
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
    }
    
//MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
    
//MARK: HideNavigationBar
    func hideNavigationBar(hide: Bool) {
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            if let self_ = self {
                self_.navigationController?.setNavigationBarHidden(hide, animated: false)
                if hide {
                    self_.scrollView.frame = CGRect(x: 0, y: 60, width: self_.width, height: self_.height - 40)
                    self_.segmentedControl.frame = CGRect(x: 0, y: 20, width: self_.width, height: 40)
                } else {
                    self_.scrollView.frame = CGRect(x: 0, y: 104, width: self_.width, height: self_.height - 104)
                    self_.segmentedControl.frame = CGRect(x: 0, y: 64, width: self_.width, height: 40)
                }
            }
        }
    }
    
}
