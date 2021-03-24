//
//  HistoryWordTVCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit

class HistoryWordTVCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var historyWordLabel: UILabel!
    
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
        
        self.iconImageView.do {
            let image = UIImage(named: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
            $0.image = image
            $0.tintColor = UIColor.secondaryLabel
        }
        
        self.historyWordLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 13), c: .black)
            $0.text = ""
            $0.textAlignment = .left
        }
    }
    
    func updateCellData(data: String?) {
        if let text = data {
            self.historyWordLabel.text = text
        }
    }
    
}
