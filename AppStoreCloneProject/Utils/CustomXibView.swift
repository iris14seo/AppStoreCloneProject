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
        
        //에러 났었음
        //required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        //}
        //해결: https://stackoverflow.com/questions/38966565/fatal-error-initcoder-has-not-been-implemented-error-despite-being-implement
    }
}
