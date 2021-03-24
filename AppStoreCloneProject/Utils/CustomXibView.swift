//
//  CustomXibView.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/02/27.
//

import UIKit

class CustomXibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let className = String(describing: type(of: self))
        let nib = UINib(nibName: className, bundle: Bundle.main)
        
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(xibView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
