//
//  UserDataCell.swift
//  GEmock

import UIKit

class UserDataCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor =  UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        locationLabel.layer.cornerRadius = 10;
        locationLabel.clipsToBounds = true
        
        cellView.layer.cornerRadius = 6;
        cellView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
