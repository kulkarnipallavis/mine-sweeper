//
//  CustomButton.swift
//  MineSweeper_1
//
//  Created by Ekveera on 1/20/17.
//  Copyright © 2017 Ekveera. All rights reserved.
//

import Foundation
import UIKit

class CustomButton  : UIButton{
    var coords = [Int]()
    var neighborTags = [Int]()
    var coordsTag : String = "11"
    
    override init(frame: CGRect) {
        self.coords = [0,0]
        self.neighborTags = [0]
        self.coordsTag = "11"

        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
