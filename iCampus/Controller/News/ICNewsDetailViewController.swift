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
    
    override func viewDidDisappear(_ animated: Bool) {
        PJHUD.dismiss()
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
                                        self_.tableView.reloadData()
                                        self_.title = detail?.title
                                        SVProgressHUD.dismiss()
                                        
                                        PJNewsPoints.setNewsPoint({[
                                            "username" : PJUser.defaultManager().first_name,
                                            "newstitle" : detail?.title
                                            ]}())
                                    }
            }, failure: {
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
    
    func createShareView() -> UIScrollView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let scrollView:UIScrollView = UIScrollView.init(frame: CGRect(x:0, y:0, width:screenWidth, height:screenHeight))
        scrollView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel.init(frame: CGRect(x:0, y:10, width:screenWidth, height:50))
        scrollView.addSubview(titleLabel)
        titleLabel.text = "iBistu 新闻"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        let titleImageView = UIImageView.init(frame: CGRect(x:titleLabel.frame.width / 2 - 50 - 45, y:titleLabel.frame.origin.y + 5, width:40, height:40))
        titleImageView.image = UIImage.init(named: "logo")
        scrollView.addSubview(titleImageView)
        
        let tableViewImageView = imageFromView(scrollView: tableView)
        tableViewImageView.frame = CGRect(x:0, y:titleLabel.frame.height + 10, width:tableViewImageView.frame.width, height:tableViewImageView.frame.height)
        scrollView.addSubview(tableViewImageView)
        
        let QRCodeImageView = UIImageView.init(frame: CGRect(x:(screenWidth - 100)/2, y: tableViewImageView.frame.height + 80, width:100, height:100))
        QRCodeImageView.image = UIImage.init(named: "QRcode")
        scrollView.addSubview(QRCodeImageView)
        
        scrollView.contentSize = CGSize(width: tableViewImageView.frame.width, height:tableViewImageView.frame.height + 170 + titleImageView.frame.height + 20)
        
        let tipsLabel = UILabel.init()
        tipsLabel.text = "下载iBistu，看更多校内新闻！"
        tipsLabel.textColor = UIColor.black;
        tipsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tipsLabel.sizeToFit()
        tipsLabel.frame = CGRect(x:(scrollView.frame.width - tipsLabel.frame.width)/2, y:scrollView.contentSize.height - 30, width:tipsLabel.frame.width, height:15)
        scrollView.addSubview(tipsLabel)
        
        return scrollView;
    }
    
    func imageFromView(scrollView:UIScrollView) -> UIImageView {
        var image:UIImage? = nil;
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale);
        let savedContentOffset = scrollView.contentOffset;
        let savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPoint.zero;
        scrollView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height);
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
        UIGraphicsEndImageContext();
        
        let imageView:UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height));
        imageView.image = image;
        
        return imageView;
    }
    
    
    //弹出分享面板
    func shareAction() {
        UMSocialUIManager.setPreDefinePlatforms([0,1,2,3,4,5])
        UMSocialUIManager.showShareMenuViewInWindow { (platformType:UMSocialPlatformType, userinfo:Any?) -> Void in

            PJNewsPoints.setNewsShare()
            
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.title = self.news.title
            //分享图片
            let shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.shareImage = self.imageFromView(scrollView: self.createShareView()).image
            messageObject.shareObject = shareObject

            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error as Any)
                }else{
                    print("Share succeed")
                }
            })
        }
    }
   
}
