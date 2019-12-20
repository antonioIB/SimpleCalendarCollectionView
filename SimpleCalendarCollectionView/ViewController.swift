//
//  ViewController.swift
//  CalendarWallet
//
//  Created by Antonio Andrew on 11/3/19.
//  Copyright © 2019 Antonio Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
//    var date = Date()

    

    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        if let layout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
//        setUpWeekdays()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        calendarCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == calendarCollectionView {
            setUpWeekdays()
        }
    }
    
    private func setUpWeekdays() {
        //get Cell width
        let columns: CGFloat = 7
        let collectionViewWidth = calendarCollectionView.bounds.width
        print("CollectionViewWidth: \(collectionViewWidth)")
        let flowLayout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        let width: CGFloat = floor(adjustedWidth / columns)

        //create 7 labels for each weekday of cell width and add them to a stack view

        let weekDView = UIStackView()
//        weekDView.translatesAutoresizingMaskIntoConstraints = false
        weekDView.axis = .horizontal
        weekDView.spacing = flowLayout.minimumInteritemSpacing
//        weekDView.widthAnchor.constraint(equalToConstant: collectionViewWidth).isActive = true
        print("Spacing: \(weekDView.spacing)")
//        weekDView.widthAnchor.constraint(equalToConstant: collectionViewWidth).isActive = true

        for i in 0...6 {
            let label = createWeekLabel(day: i)
            label.widthAnchor.constraint(equalToConstant: width).isActive = true
            weekDView.addArrangedSubview(label)
        }
        
        navigationItem.titleView = weekDView
        
        if UIDevice.current.orientation.isLandscape {
            if let navSuperView = navigationItem.titleView?.superview {
                NSLayoutConstraint.activate([(navigationItem.titleView?.centerXAnchor.constraint(equalTo: navSuperView.centerXAnchor))!,
                                             (navigationItem.titleView?.centerYAnchor.constraint(equalTo: navSuperView.centerYAnchor))!,
                                             (navigationItem.titleView?.widthAnchor.constraint(equalToConstant: collectionViewWidth))!,
                                             (navigationItem.titleView?.heightAnchor.constraint(equalTo: navSuperView.heightAnchor))! ])
            }
        } else {
            if let navSuperView = navigationItem.titleView?.superview {
                NSLayoutConstraint.activate([(navigationItem.titleView?.centerXAnchor.constraint(equalTo: navSuperView.centerXAnchor))!,
                                             (navigationItem.titleView?.centerYAnchor.constraint(equalTo: navSuperView.centerYAnchor))!,
                                             (navigationItem.titleView?.leadingAnchor.constraint(equalTo: navSuperView.leadingAnchor))!,
                                             (navigationItem.titleView?.heightAnchor.constraint(equalTo: navSuperView.heightAnchor))! ])
            }
        }
    }
    
    private func createWeekLabel(day: Int) -> UILabel {
        let label = UILabel()
        label.text = dateFormatter.shortWeekdaySymbols[day]
        label.textAlignment = .center
        return label
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    // working
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var currComponents = DateComponents()
        currComponents.year = calendar.component(.year, from: Date())
        currComponents.month = section + 1
        let date = calendar.date(from: currComponents)!
        
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
        let startOfNextMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth))!
        let lastDay = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth)!
        let nDays = calendar.component(.day, from: lastDay)
        
        let firstWeekday = calendar.component(.weekday, from: date)
        
        if firstWeekday >= 6 && nDays == 31 {
            return 42
        }
        if firstWeekday >= 7 && nDays > 29 {
            return 42
        }
        return 35
    }
    // working
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCollectionViewCell

        var currComponents = DateComponents()
        currComponents.year = calendar.component(.year, from: Date())
        currComponents.month = indexPath.section + 1
        let date = calendar.date(from: currComponents)!
        
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
        let startOfNextMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth))!
        let lastDay = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth)!
        let nDays = calendar.component(.day, from: lastDay)
        
        let currDate = indexPath.item - firstWeekday + 2
        if (indexPath.item + 1) < firstWeekday || currDate > nDays {
            cell.contentView.alpha = 0
        } else {
            cell.contentView.alpha = 1
            cell.setup(dayNumber: currDate)
        }
        
        return cell
    }
    //working
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 7
        let collectionViewWidth = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        let width: CGFloat = floor(adjustedWidth / columns)
        
        let rows: CGFloat = 5
        let collectionViewHeight = collectionView.bounds.height
        let spaceBetweenRows = flowLayout.minimumInteritemSpacing * (rows - 1)
        let adjustedHeight = collectionViewHeight - spaceBetweenRows
        let height: CGFloat = floor(adjustedHeight / rows)
        
//        setUpWeekdays()
        
        
        return CGSize(width: width, height: height)
    }
    //working
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeaderView
        
        var currComponents = DateComponents()
        currComponents.year = calendar.component(.year, from: Date())
        currComponents.month = indexPath.section + 1
        let date = calendar.date(from: currComponents)!
        dateFormatter.dateFormat = "MMMM"
        view.setup(text: dateFormatter.string(from: date))
        
        return view
    }
}
