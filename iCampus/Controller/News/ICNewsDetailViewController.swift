//
//  ICNewsDetailViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/11.
//  Copyright © 2017年 ifLab. All rights reserved.
//

import UIKit
import MJRefresh
import DTCoreText
import SVProgressHUD

class ICNewsDetailViewController: UITableViewController, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {

    lazy var textCell: DTAttributedTextCell = {
        let c = DTAttributedTextCell()
        c.attributedTextContextView.delegate = self
        c.attributedTextContextView.shouldDrawLinks = true
        return c
    }()
    var news: ICNews
    var newsDetail: ICNewsDetail?
    
    init(news: ICNews) {
        self.news = news
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = UIColor.black
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        //Umeng share button
        let shareBtn = UIBarButtonItem(image: UIImage.init(named: "newsShare"), style: .done, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareBtn
        refresh()
    }
    
    //MARK: MJRerfresh
    func refresh() {
        SVProgressHUD.show()
        ICNewsDetail.newsDetail(with: news,
                                success: {
                                    [weak self] detail in
                                    if let self_ = self {
                                        self_.newsDetail = detail
                                        let options = [
                                            DTDefaultFontName: UIFont.systemFont(ofSize: 0).fontName,
                                            DTDefaultFontSize: 16,
                                            DTDefaultTextColor: UIColor.black,
                                            DTDefaultLineHeightMultiplier: 1.5,
                                            DTDefaultLinkDecoration: false] as [String : Any]
                                        self_.textCell.setHTMLString(detail?.body!, options: options)
//                                        self_.tableView.mj_header.endRefreshing()
                                        self_.tableView.reloadData()
                                        self_.title = detail?.title
                                        SVProgressHUD.dismiss()
                                    }
            },
                                failure: {
                                    [weak self] _ in
                                    self?.tableView.separatorStyle = .singleLine
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return textCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return textCell.requiredRowHeight(in: tableView)
    }
    
    // MARK: DTLazyImageViewDelegate
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment is DTImageTextAttachment {
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.url = attachment.contentURL
            return imageView
        }
        return nil
    }

    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let predicate = NSPredicate(format: "contentURL == %@", lazyImageView.url as CVarArg)
        let attachments = textCell.attributedTextContextView.layoutFrame.textAttachments(with: predicate) as? [DTImageTextAttachment] ?? []
        for attachment in attachments {
            attachment.originalSize = size
            let v = textCell.attributedTextContextView!
            let maxWidth = v.bounds.width - v.edgeInsets.left - v.edgeInsets.right
            if size.width > maxWidth {
                let scale = maxWidth / size.width
                attachment.displaySize = CGSize(width: size.width * scale, height: size.height * scale)
            }
        }
        textCell.attributedTextContextView.layouter = nil
        textCell.attributedTextContextView.relayoutText()
        tableView.reloadData()
    }
    
    func imageFromView(theView:UITableView) -> UIImage {
        let savedContentOffset:CGPoint = theView.contentOffset
        let savedFrame:CGRect = theView.frame
        
        theView.contentOffset = CGPoint.zero
        theView.frame = CGRect(x:0,y:0,width:theView.contentSize.width,height:theView.contentSize.height)
        
        //ScrollView
//        let scrollView:UIScrollView = UIScrollView.init()
//
//        let headerView:UIView = UIView.init()
//        headerView.backgroundColor = .black
//        headerView.frame = CGRect(x:0,y:0,width:savedFrame.width,height:40)
//        let logoImage:UIImageView = UIImageView.init(image: UIImage (named: "logo"))
//        logoImage.frame = CGRect(x:4,y:4,width:36,height:36)
//        headerView.addSubview(logoImage)
//        let logoTitleLabel:UILabel = UILabel.init()
        let shareView:ZKNewsDetailShareView = ZKNewsDetailShareView.init()
        shareView.newsTitle = self.news.title! as NSString
        UIGraphicsBeginImageContextWithOptions(theView.frame.size,true,0.0)
        theView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        shareView.imageSize = theView.frame.size;
        shareView.image = theImage;
        theView.contentOffset = savedContentOffset
        theView.frame = savedFrame
        
        UIGraphicsBeginImageContextWithOptions(shareView.view.frame.size,true,0.0)
        shareView.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        theImage =  UIGraphicsGetImageFromCurrentImageContext()!
        
        return theImage
    }
    
    
    //弹出分享面板
    func shareAction() {

        UMSocialUIManager.setPreDefinePlatforms([0,1,2,3,4,5])
        UMSocialUIManager.showShareMenuViewInWindow { (platformType:UMSocialPlatformType, userinfo:Any?) -> Void in

            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.title = self.news.title
            //分享图片
            let shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.shareImage = self.imageFromView(theView: self.tableView)
            messageObject.shareObject = shareObject


            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error)
                }else{
                    print("Share succeed")
                    
                }
            })

        }
    }
   
}
