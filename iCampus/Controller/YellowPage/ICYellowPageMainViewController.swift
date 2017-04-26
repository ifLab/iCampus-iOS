//
//  ICYellowPageMainViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/23.
//  Copyright © 2017年 ifLab. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SVProgressHUD

class ICYellowPageMainViewController: UIViewController, UIScrollViewDelegate, ICYellowPageParentDelegate {
    
    var channels = [ICYellowPageChannel]()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: 104, width: self.width, height: self.height - 104))
        s.backgroundColor = .white
        s.isPagingEnabled = true
        s.showsHorizontalScrollIndicator = false
        s.delegate = self
        return s
    }()
    var viewConstraints = [NSLayoutConstraint]()
    var segmentTopConstraintNavHide = NSLayoutConstraint()
    var segmentTopConstraintNavUnHide = NSLayoutConstraint()
    lazy var childControllers = [ICYellowPageViewController]()
    lazy var segmentedControl: HMSegmentedControl = {
        let sc = HMSegmentedControl(frame: CGRect(x: 0, y: 64, width: self.width - 40, height: 40))
        sc.selectionStyle = .textWidthStripe
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setBackgroundLayerColor(.white)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        ICYellowPageChannel.fetch({
            [weak self] data in
            if let self_ = self {
                self_.channels = data as! [ICYellowPageChannel]
                self_.loadViews()
                SVProgressHUD.dismiss()
            }
        }) { [weak self] message in
            if let self_ = self {
                SVProgressHUD.setDefaultMaskType(.none)
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: message ?? "未知错误")
                self_.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "黄页"
        view.backgroundColor = .white
    }
    
    func loadViews() {
        segmentedControl.sectionTitles = channels.map({$0.name})
        view.addSubview(segmentedControl)
        
        scrollView.contentSize = CGSize(width: width * CGFloat(channels.count) , height: scrollView.frame.height)
        for i in 0..<self.channels.count {
            let channel = self.channels[i]
            let c = ICYellowPageViewController(channel: channel)
            c.delegate = self
            c.view.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height - 104)
            childControllers.append(c)
        }
        view.addSubview(scrollView)
        for v in childControllers {
            scrollView.addSubview(v.view)
            addChildViewController(v)
        }
        segmentedControl.indexChangeBlock = {
            [weak self] index in
            if let self_ = self {
                self_.scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * self_.width, y: 0, width: self_.width, height: self_.height), animated: true)
                self_.childControllers[index].headerBeginRefresh()
            }
        }
        childControllers[0].headerBeginRefresh()
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
