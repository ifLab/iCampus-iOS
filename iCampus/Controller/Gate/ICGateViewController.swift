//
//  ICGateViewController.swift
//  iCampus
//
//  Created by Bill Hu on 16/12/14.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit
//import PJYellowPageViewController

class ICGateViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    var identifier = "ICGateViewCell"
    let itemTitles = ["新闻",
                      "黄页",
                      "校车",
                      "地图",
//                      "兼职",
//                      "成绩",
//                      "课程",
//                      "教室",
                      "失物招领",
                      "关于",
                      ]
    let itemImageNames = ["ICGateNewsIcon",
                          "ICGateYellowPageIcon",
                          "ICGateBusIcon",
                          "ICGateMapIcon",
                          "二手货",
                          "About",
                          ]
    let itemIdentifiers = [ICNewsMainViewController.self,
                           PJYellowPageViewController.self,
                           PJBusViewController.self,
                           ICNewsMainViewController.self,
                           ICNewsMainViewController.self,
                           PJAboutViewController.self,
                           ] as [Any]
    
//    MARK: - Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iBistu"
        collectionView?.register(
            UINib(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        collectionView?.backgroundColor = .white
    }
    
//    MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ICGateViewCell
        cell.update(image: itemImageNames[indexPath.item], label: itemTitles[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemTitles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = (itemIdentifiers[indexPath.item] as! UIViewController.Type).init()
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInLine: CGFloat = 3
        let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let itemWidth = (collectionView.frame.width) / numberOfItemsInLine - inset.left - inset.right
        let itemHeight = itemWidth + 20
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 30.0
    }
    
    @nonobjc internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
