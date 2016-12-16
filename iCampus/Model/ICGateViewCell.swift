//
//  ICGateViewCell.swift
//  iCampus
//
//  Created by Bill Hu on 16/12/15.
//  Copyright © 2016年 BISTU. All rights reserved.
//

import UIKit

class ICGateViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(image: String, label: String) {
        imageView.image = UIImage(named: image)
        self.label.text = label
    }

}
