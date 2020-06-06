//
//  SportsFilterStartTimeCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterStartTimeCollectionViewCell: SportsFilterCollectionViewCell {

    static let height: CGFloat = 103

    private let startTimeLabel = UILabel()
    private let startTimeSlider = RangeSeekSlider(frame: .zero)

    private var endTime = "10:00PM"
    private var startTime = "6:00AM"
    private var timeFormatter = DateFormatter()
    private var timeRanges: [Date] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        let cal = Calendar.current
        let currDate = Date()
        let startDate = cal.date(bySettingHour: 6, minute: 0, second: 0, of: currDate)!
        let endDate = cal.date(bySettingHour: 22, minute: 0, second: 0, of: currDate)!

        var date = startDate

        while date <= endDate {
            timeRanges.append(date)
            date = cal.date(byAdding: .minute, value: 15, to: date)!
        }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"

        titleLabel.text = ClientStrings.Filter.startTime

        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12MontserratBold
        startTimeLabel.textColor = .gray04
        startTimeLabel.text = startTime + " - " + endTime
        contentView.addSubview(startTimeLabel)

        startTimeSlider.minValue = 0.0 //15 minute intervals
        startTimeSlider.maxValue = 960.0
        startTimeSlider.selectedMinValue = 0.0
        startTimeSlider.selectedMaxValue = 960.0
        startTimeSlider.enableStep = true
        startTimeSlider.delegate = self
        startTimeSlider.step = 15.0
        startTimeSlider.handleDiameter = 24.0
        startTimeSlider.selectedHandleDiameterMultiplier = 1.0
        startTimeSlider.lineHeight = 6.0
        startTimeSlider.hideLabels = true
        startTimeSlider.colorBetweenHandles = .primaryYellow
        startTimeSlider.handleColor = .white
        startTimeSlider.handleBorderWidth = 1.0
        startTimeSlider.handleBorderColor = .gray01
        startTimeSlider.handleShadowColor = .gray02
        startTimeSlider.handleShadowOffset = CGSize(width: 0, height: 2)
        startTimeSlider.handleShadowOpacity = 0.6
        startTimeSlider.handleShadowRadius = 1.0
        startTimeSlider.tintColor = .gray01
        contentView.addSubview(startTimeSlider)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        let startTimeLabelTrailingOffset = -22
        let startTimeSliderHeight = 30
        let startTimeSliderLeadingTrailingOffset = 16
        let startTimeSlidertopOffset = 12

        startTimeLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(startTimeLabelTrailingOffset)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        startTimeSlider.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-startTimeSliderLeadingTrailingOffset)
            make.leading.equalToSuperview().offset(startTimeSliderLeadingTrailingOffset)
            make.top.equalTo(startTimeLabel.snp.bottom).offset(startTimeSlidertopOffset)
            make.height.equalTo(startTimeSliderHeight)
        }
    }

}

extension SportsFilterStartTimeCollectionViewCell: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let minValueIndex = Int(minValue / 15.0)
        let maxValueIndex = Int(maxValue / 15.0)

        let minDate = timeRanges[minValueIndex]
        let maxDate = timeRanges[maxValueIndex]

        startTimeLabel.text = "\(timeFormatter.string(from: minDate)) - \(timeFormatter.string(from: maxDate))"
    }

}
