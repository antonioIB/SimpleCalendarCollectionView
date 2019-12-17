//
//  MonthHeaderView.swift
//  CalendarWallet
//
//  Created by Antonio Andrew on 11/18/19.
//  Copyright © 2019 Antonio Andrew. All rights reserved.
//

import UIKit

class MonthHeaderView: UICollectionReusableView {
    @IBOutlet weak var monthHeaderLabel: UILabel!
    
    func setup(text: String){
        monthHeaderLabel.text = text
    }
}
