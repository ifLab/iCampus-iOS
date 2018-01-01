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
    let itemTitles = [""];
//                      "新闻",
//                      "黄页",
//                      "校车",
//                      "地图",
//                      "兼职",
//                      "成绩",
//                      "课程",
//                      "教室",
//                      "失物招领",
//                      "关于",
//                      ]
    let limitedTitles = ["黄页",
                         "失物招领",
    ]//需要登录并认证的栏目
    let itemImageNames = ["ICGateNewsIcon",
                          "ICGateYellowPageIcon",
                          "ICGateBusIcon",
                          "ICGateMapIcon",
                          "二手货",
//                          "About",
                          ]
    let itemIdentifiers = [ICNewsMainViewController.self,
                           PJYellowPageViewController.self,
                           PJBusViewController.self,
                           PJMapViewController.self,
                           PJLostViewController.self,
//                           PJAboutViewController.self,
                           ] as [Any]
    
//    MARK: - Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iBistu"
        let rightItemImg = UIImage(named: "user")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        let rightItem = UIBarButtonItem.init(image: rightItemImg, style: UIBarButtonItemStyle.done, target: self, action: #selector(ICGateViewController.pushUserVC))
        self.navigationItem.rightBarButtonItem = rightItem;
        collectionView?.register(
            UINib(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        collectionView?.backgroundColor = .white
    }
    
    func pushUserVC() {
        if PJUser.current() == nil {
            let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first as! ICLoginViewController
            present(controller, animated: true, completion: nil)
        } else {
            let mainStoryboard = UIStoryboard(name:"PJUserSB", bundle:nil)
            var vc = PJUserViewController.init();
            vc = mainStoryboard.instantiateViewController(withIdentifier: "PJUserViewController") as! PJUserViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func isLimited(title: String) -> Bool {
        for li in limitedTitles {
            if li == title {
                return true
            }
        }
        return false
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
        if isLimited(title: itemTitles[indexPath.item]) {//需要登录并且认证
            if ICNetworkManager.default().token != nil && ICNetworkManager.default().token != "" {//logined
                if !CASBistu.checkCASCertified() && CASBistu.showCASController() {//CAS not certified
                    
                    let controller = Bundle.main.loadNibNamed("ICCASViewController", owner: nil, options: nil)?.first as! ICCASViewController
                    present(controller, animated: true, completion: nil)
                    return
                }
                //logined and CAS certified, present after exit if.
            } else {//didn't login, present LoginVC
                let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first as! ICLoginViewController
                present(controller, animated: true, completion: nil)
                return
            }
        }
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
