//
//  DayCollectionViewCell.swift
//  CalendarWallet
//
//  Created by Antonio Andrew on 11/3/19.
//  Copyright © 2019 Antonio Andrew. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    func setup(dayNumber: Int){
        dayLabel.text = "\(dayNumber)"
    }
}
