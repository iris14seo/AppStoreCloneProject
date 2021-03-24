//
//  MainTVCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit

class MainTVCell: UITableViewCell {

    @IBOutlet var historyWordLabel: UILabel!
    
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
        
        self.contentView.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.historyWordLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 18), c: .systemBlue)
        }
    }
    
    func updateCellData(text: String) {
        self.historyWordLabel.text = text
    }
}
