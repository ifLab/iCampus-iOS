//
//  ICNewsMainViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/4.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit
import HMSegmentedControl

class ICNewsMainViewController: UIViewController, UIScrollViewDelegate, ICNewsParentDelegate {
    
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
    lazy var childControllers: [ICNewsTableViewController] = {
        var c = [ICNewsTableViewController]()
        for i in 0..<self.titles.count {
            let title = self.titles[i]
            let t = ICNewsTableViewController(category: self.categorys[i], title: self.titles[i])
            t.delegate = self
            t.view.frame = CGRect(x: CGFloat(i) * self.width, y: 0, width: self.width, height: self.height - 104 - 22)
            c.append(t)
        }
        return c
    }()
    lazy var segmentedControl: HMSegmentedControl = {
        let sc = HMSegmentedControl(sectionTitles: self.titles)!
        sc.frame = CGRect(x: 0, y: 64, width: self.width, height: 40)
        sc.selectionStyle = .fullWidthStripe
        sc.selectionIndicatorLocation = .down
        sc.selectionIndicatorColor = .blue
        sc.selectionIndicatorHeight = 3
        sc.titleFormatter =  {
            (_, title, _, _) -> NSAttributedString? in
            let attr = NSAttributedString(string: title!, attributes: [NSForegroundColorAttributeName: UIColor.black])
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
                self_.childControllers[index].headerBeginRefresh()
            }
        }
        childControllers[0].headerBeginRefresh()
        
        /*************************/
        /* 测试分享使用，后期删除 */
        
        let shareBtn = UIBarButtonItem.init(image: UIImage.init(named: "share1"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareBtn
        /*************************/
    }
    
//MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
    
//MARK: HideNavigationBar
    func hideNavigationBar(hide: Bool) {
        UIView.animate(withDuration: 0.2) {
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
    
    /*************************/
    /* 测试分享使用，后期删除 */
    
    //弹出分享面板
    func shareAction() {
        print("share")
        UMSocialUIManager.setPreDefinePlatforms([0,1,2,3,4,5])
        UMSocialUIManager.showShareMenuViewInWindow { (platformType:UMSocialPlatformType, userinfo:Any?) -> Void in
            
            //分享文本测试
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "社会化组件UShare将各大社交平台接入您的应用，快速武装App。iBistu 分享测试"//分享的文本
            
            //分享图片
            let shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.shareImage = "https://mobile.umeng.com/images/pic/home/social/img-1.png"
            messageObject.shareObject = shareObject

            
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
//                    print("Share Fail with error ：%@", error)
                }else{
//                    print("Share succeed")
                }
            })
            
        }
    }
    
    /* END */
    /*************************/
    
}
