//
//  ICSimpleImageViewCell.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/6.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit

class ICSimpleImageViewCell: UITableViewCell, ICNewsViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(news: ICNews) {
        titleLabel.text = news.title
        dateLabel.text = news.date
        newsImageView.setImageWith(URLRequest(url: URL(string: news.imageURL)!), placeholderImage: nil, success: {
            [weak self] _, _, image in
            self?.newsImageView.image = image
        }, failure: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
