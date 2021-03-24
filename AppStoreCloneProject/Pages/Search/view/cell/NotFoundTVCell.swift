//
//  NotFoundTVCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit

class NotFoundTVCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var notFoundLabel: UILabel!
    @IBOutlet var keyWordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initStyle() {
        self.selectionStyle = .none
        
        self.notFoundLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 26), c: .black)
            $0.textAlignment = .center
        }
        
        self.keyWordLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 15), c: .secondarySystemFill)
            $0.textAlignment = .center
        }
    }
    
    func updateCellData(keyWord: String) {
        self.keyWordLabel.text = "'\(keyWord)'"
    }
    
}
