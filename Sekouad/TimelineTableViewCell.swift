//
//  TimelineTableViewCell.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(sekouad: Sekouad) {
        titleLabel.text = sekouad.title
        timeLabel.text = sekouad.lastUpdate
        categoryLabel.text = sekouad.emoji
        thumbnailImageView.image = UIImage(named: sekouad.thumbnail ?? "")
        
        // Rounded thumbnail
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width / 2
        thumbnailImageView.clipsToBounds = true
    }

}
