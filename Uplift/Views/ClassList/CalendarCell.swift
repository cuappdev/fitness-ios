//
//  CalendarCell.swift
//  Uplift
//
//  Created by Cornell AppDev on 3/26/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let dateLabel = UILabel()
    private let dateLabelCircle = UIView()
    private let dayOfWeekLabel = UILabel()

    override func prepareForReuse() {
        dateLabelCircle.isHidden = true
        dateLabel.textColor = .gray04
        dayOfWeekLabel.textColor = .gray04
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure
    func configure(for dateLabelText: String,
                   dateLabelTextColor: UIColor?,
                   dateLabelFont: UIFont,
                   dayOfWeekLabelText: String,
                   dayOfWeekLabelTextColor: UIColor?,
                   dayOfWeekLabelFont: UIFont,
                   dateLabelCircleIsHidden: Bool
        ) {
        if let dateLabelTextColor = dateLabelTextColor {
            dateLabel.textColor = dateLabelTextColor
        }
        if let dayOfWeekLabelTextColor = dayOfWeekLabelTextColor {
            dayOfWeekLabel.textColor = dayOfWeekLabelTextColor
        }

        dateLabel.text = dateLabelText
        dateLabel.font = dateLabelFont
        dayOfWeekLabel.text = dayOfWeekLabelText
        dayOfWeekLabel.font = dayOfWeekLabelFont
        dateLabelCircle.isHidden = dateLabelCircleIsHidden
    }

    // MARK: - Private helpers
    private func setupViews() {
        dateLabelCircle.backgroundColor = .primaryYellow
        dateLabelCircle.isHidden = true
        dateLabelCircle.layer.cornerRadius = 12
        addSubview(dateLabelCircle)

        dateLabel.font = ._12MontserratMedium
        dateLabel.textAlignment = .center
        dateLabel.textColor = .gray04
        dateLabel.sizeToFit()
        addSubview(dateLabel)

        dayOfWeekLabel.font = ._12MontserratMedium
        dayOfWeekLabel.textAlignment = .center
        dayOfWeekLabel.textColor = .gray04
        dayOfWeekLabel.sizeToFit()
        addSubview(dayOfWeekLabel)
    }

    private func setupConstraints() {
        let dateLabelCircleLength = 24
        let dateLabelTopPadding = 12

        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dayOfWeekLabel.snp.bottom).offset(dateLabelTopPadding)
        }

        dayOfWeekLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        dateLabelCircle.snp.makeConstraints { make in
            make.height.width.equalTo(dateLabelCircleLength)
            make.center.equalTo(dateLabel)
        }
    }
}
