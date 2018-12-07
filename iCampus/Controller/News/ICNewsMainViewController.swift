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
//    var titles: [String]?
//    var categorys: [String]?
    
    var channels: [ICNewsChannel]?
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    lazy var scrollView: UIScrollView = {
        var s = UIScrollView.init()
        if PJCurrentPhone.pjCurrentPhone("iPhoneX") {
            s.frame = CGRect(x: 0, y: 130, width: self.width, height: self.height - 124)
        } else {
            s.frame = CGRect(x: 0, y: 104, width: self.width, height: self.height - 104)
        }
        s.contentSize = CGSize(width: self.width * CGFloat((self.channels?.count)!) , height: s.frame.height)
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
        var i = 0
        for channel in self.channels! {
            let title = channel.chnlname
            let t = ICNewsTableViewController(category: channel.chnlurl, title: title!)
            t.view.frame = CGRect(x: CGFloat(i) * self.width, y: 0, width: self.width, height: self.height - 104 - 22)
            c.append(t)
            i += 1
        }
        return c
    }()
    
    lazy var segmentedControl: HMSegmentedControl = {
        var titles = [String]()
        
        for channel in self.channels! {
            titles.append(channel.chnlname)
        }

        let sc = HMSegmentedControl(sectionTitles: titles)!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name("UserDidLoginNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newsItemDidSelectedNotification), name: NSNotification.Name("NewsItemDidSelectedNotification"), object: nil)
        
        SVProgressHUD.show()
        ICNewsChannel.getWithSuccess({ (channels) in
            self.channels = channels
            print("栏目加载成功")
            SVProgressHUD.dismiss()
            
            self.view.addSubview(self.segmentedControl)
            self.segmentedControl.indexChangeBlock = {
                [weak self] index in
                if let self_ = self {
                    self_.scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * self_.width, y: 0, width: self_.width, height: self_.height), animated: true)
                }
            }
            
            self.view.addSubview(self.scrollView)
            for v in self.childControllers {
                self.scrollView.addSubview(v.view)
                self.addChildViewController(v)
            }
            
            if PJUser.current() != nil {
                self.childControllers[0].headerBeginRefresh()
            }
            
        }) { (err) in
            print(err as Any)
            SVProgressHUD.showError(withStatus: "加载失败,\(err!)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func newsItemDidSelectedNotification() {
        if childControllers[segmentedControl.selectedSegmentIndex].tableView.contentOffset.y > 0 {
            childControllers[segmentedControl.selectedSegmentIndex].tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }else {
            childControllers[segmentedControl.selectedSegmentIndex].headerBeginRefresh()
        }
    }
    
    func loginRefresh() {
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
