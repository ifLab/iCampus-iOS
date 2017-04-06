//
//  ICNoneImageViewCell.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/6.
//  Copyright © 2017年 BISTU. All rights reserved.
//

import UIKit

class ICNoneImageViewCell: UITableViewCell, ICNewsViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(news: ICNews) {
        titleLabel.text = news.title
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-DD"
        dateLabel.text = df.string(from: news.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
