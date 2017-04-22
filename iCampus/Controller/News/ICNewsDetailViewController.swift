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
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: MJRerfresh
    func refresh() {
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
                                        self_.tableView.mj_header.endRefreshing()
                                        self_.tableView.reloadData()
                                    }
            },
                                failure: {
                                    [weak self] _ in
                                    self?.tableView.separatorStyle = .singleLine
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: ScrollView Delegate
    //MARK: HideNavigationBar
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        let threshold: CGFloat = 200
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            if let self_ = self {
                if offset > 0 && velocity < 0 {
                    self_.navigationItem.setHidesBackButton(true, animated: false)
                    self_.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0)
                }
                if velocity >= threshold {
                    self_.navigationItem.setHidesBackButton(false, animated: false)
                    self_.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44)
                }
            }
        }
    }
   
}
