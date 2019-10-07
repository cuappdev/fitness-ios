//
//  GymWeekCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/6/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class GymWeekCell: UICollectionViewCell {

    // MARK: -Identifier
    static let identifier = Identifiers.gymWeekCell

    // MARK: -Views
    private var dayLabel: UILabel!
    private var backCircle: UIView!

    // MARK: -Sizing
    private let circleSize = CGSize(width: 24, height: 24)

    // MARK: -Info
    /// Weekday this cell represents
    private var day = WeekDay.sunday
    /// Weekday representing current day of week
    private var today = WeekDay.sunday
    

    // MARK: -Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Set up today with Name of Day of week
        

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -Setup
    private func setupViews() {
        backCircle = UIView()
        backCircle.layer.cornerRadius = circleSize.width / 2
        self.addSubview(backCircle)

        dayLabel = UILabel()
        dayLabel.font = ._16MontserratBold
        self.addSubview(dayLabel)

        update()
    }

    private func setupConstraints() {
        backCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(circleSize)
        }

        dayLabel.snp.makeConstraints { make in
            make.center.equalTo(backCircle)
        }
    }

    // MARK: -Functionality
    func configure(weekday: WeekDay, today: WeekDay) {
        day = weekday
        self.today = today
        dayLabel.text = weekday.rawValue
        update()
    }

    /**
     Updates the appearence of the cell when selection changes
     */
    func update() {
        // Selection
        if isSelected { // If selected
            backCircle.backgroundColor = .fitnessYellow
            backCircle.alpha = 1
        } else { // Not selected
            if today == day { // Cell represents today
                backCircle.backgroundColor = .fitnessClearGrey
                backCircle.alpha = 1
            } else { // Cell represents some other day of week
                backCircle.backgroundColor = .fitnessClearGrey
                backCircle.alpha = 0
            }
        }
    }
}