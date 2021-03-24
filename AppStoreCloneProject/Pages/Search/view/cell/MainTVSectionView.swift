//
//  MainTVSectionView.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit

class MainTVSectionView: UITableViewHeaderFooterView {

    @IBOutlet var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
    }
    
    func initStyle() {
         
        self.contentView.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.sectionTitleLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 25), c: .label)
            $0.textAlignment = .left
            $0.text = "최근 검색어"
        }
    }

}
