//
//  RecentWordTableViewCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit

class RecentWordTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initStyle() {
        self.selectionStyle = .none
        
        self.wordLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 14), c: .black)
            $0.text = ""
            $0.textAlignment = .left
        }
    }
    
    func updateData(word: String?) {
        if let word = word {
            self.wordLabel.text = word
        }
    }
    
}
