//
//  TimelineTableViewCell.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(sekouad: Sekouad, indexPath: IndexPath) {
        titleLabel.text = sekouad.title
        timeLabel.text = sekouad.lastUpdate
        categoryLabel.text = sekouad.emoji
        thumbnailImageView.image = UIImage(named: sekouad.thumbnail ?? "")
        
        // Rounded thumbnail
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width / 2
        thumbnailImageView.clipsToBounds = true
        
        // Hide separator under header view
        if indexPath.row == 0 {
            separatorView.isHidden = true
        }
        
        // Hide more button more sekouads other than ours
        if indexPath.section != 0 {
            moreButton.isHidden = true
        }
    }

}
