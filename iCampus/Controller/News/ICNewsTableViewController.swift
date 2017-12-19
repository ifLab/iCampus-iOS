//
//  ICNewsTableViewController.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/6.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit
import MJRefresh

@objc protocol ICNewsViewCell {
    func update(news: ICNews)
}

protocol ICNewsParentDelegate {
    func hideNavigationBar(hide: Bool)
}

class ICNewsTableViewController: UITableViewController {
    
    var delegate: ICNewsParentDelegate?
    var page = 1
    var channel: ICNewsChannel
    var news = [ICNews]()
    let nibNames = ["ICNoneImageViewCell", "ICSimpleImageViewCell"]
    
    init(category: String, title: String) {
        channel = ICNewsChannel()
        channel.listKey = category
        channel.title = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        title = channel.title
        for nibName in nibNames {
            tableView.register(UINib(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: nibName)
        }
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        //原数据为80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        refresh()
    }
//    override func viewDidLoad() {
//    super.viewDidLoad()
//        refresh()
//    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if news[indexPath.row].imageURL == "" {
            cell = tableView.dequeueReusableCell(withIdentifier: nibNames[0], for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: nibNames[1], for: indexPath)
        }
        (cell as! ICNewsViewCell).update(news: news[indexPath.row])
        return cell
    }
    
    // MARK: MJRefresh
    
    internal func headerBeginRefresh() {
        tableView.mj_header.beginRefreshing()
    }
    
    func refresh() {
        ICNews.fetch(channel, page: 1,
                     success: {
                        [weak self] data in
                        self?.tableView.mj_header.endRefreshing()
                        self?.news = data as! [ICNews]
                        self?.tableView.separatorStyle = .singleLine
                        self?.tableView.reloadData()
                        self?.page = 2
            },
                     failure: {
                        [weak self] _ in
                        self?.tableView.mj_header.endRefreshing()
                        self?.tableView.separatorStyle = .singleLine
        })
    }
    
    func loadMore() {
        ICNews.fetch(channel, page: page,
                     success: {
                        [weak self] data in
                        self?.tableView.mj_footer.endRefreshing()
                        self?.news.append(contentsOf: data as! [ICNews])
                        self?.tableView.separatorStyle = .singleLine
                        self?.tableView.reloadData()
                        self?.page += 1
            },
                     failure: {
                        [weak self] error in
                        self?.tableView.mj_footer.endRefreshing()
                        self?.tableView.separatorStyle = .singleLine
        })
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsDetailView:ICNewsDetailViewController = ICNewsDetailViewController(news: news[indexPath.row])
        newsDetailView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newsDetailView, animated: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        let threshold: CGFloat = 200
        if offset > 0 && velocity < 0 {
            delegate?.hideNavigationBar(hide: true)
        }
        if velocity >= threshold {
            delegate?.hideNavigationBar(hide: false)
        }
    }
    
}
