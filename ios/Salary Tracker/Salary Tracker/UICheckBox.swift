//
//  UICheckBox.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/20/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import UIKit

class UICheckBox : UIButton {
    var checkedImage = UIImage(named: "checkbox_checked");
    var uncheckedImage = UIImage(named: "checkbox_unchecked");
    
    var isChecked:Bool = false{
        didSet{
            if isChecked{
                setImage(checkedImage, forState: .Normal);
            } else{
                setImage(uncheckedImage, forState: .Normal);
            }
        }
    }
    
    init(){
        super.init(frame: CGRectZero);
        self.addTarget(self, action: "clicked:", forControlEvents: .TouchUpInside);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.addTarget(self, action: "clicked:", forControlEvents: .TouchUpInside);
    }
    
    func clicked(sender: UICheckBox){
        self.isChecked = !isChecked;
    }
}
