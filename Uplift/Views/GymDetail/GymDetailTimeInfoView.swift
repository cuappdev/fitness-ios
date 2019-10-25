//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UILabel {

    var facility: Facility
    private var selectedDayIndex = 0
    private var displayedText: String = ""
    private var timesText = NSMutableAttributedString()
    private var paragraphStyle = NSMutableParagraphStyle()

    init(facility: Facility) {
        self.facility = facility
        super.init(frame: CGRect())

        timesText.mutableString.setString(displayedText)

        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.maximumLineHeight = 26
        paragraphStyle.alignment = .center

        attributedText = timesText
        backgroundColor = .primaryWhite
        numberOfLines = 0
        font = ._16MontserratRegular
        textColor = .primaryBlack
        textAlignment = .center

        updateTimes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    private func updateAppearence() {
        updateTimes()
    }

    private func updateTimes() {
        displayedText = getDisplayText(dayIndex: selectedDayIndex)
        updateAttributedText()
    }

    private func updateTags() {
        let tagLabelWidth = 81
        let tagSideOffset = 25.0
        let textLineHeight = font.lineHeight

        let info = facility.miscInformation
        subviews.forEach({ $0.removeFromSuperview() })

        for i in 0..<info.count {
            if info[i] == "" { // Don't use blank tags
                continue
            } else {
                let infoView = AdditionalInfoView()
                let spacing = textLineHeight * CGFloat(i)
                let inset: CGFloat = 2

                infoView.text = info[i]
                addSubview(infoView)
                infoView.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(spacing + inset)
                    make.trailing.equalToSuperview().inset(tagSideOffset)
                    make.width.equalTo(tagLabelWidth)
                }
            }
        }

        updateConstraints()
    }

    func updateAttributedText() {
        timesText.mutableString.setString(displayedText)
        let range = NSMakeRange(0, timesText.length)
        timesText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attributedText = timesText
    }

    // MARK: - Helper
    func getDisplayText(dayIndex: Int) -> String {
        let dayTimes = facility.times.filter { $0.dayOfWeek == dayIndex }
        let timeStrings: [String] = dayTimes.map { getStringFromDailyGymHours(dailyGymHours: $0) }
        return timeStrings.joined(separator: "\n")
    }

    func getStringFromDailyGymHours(dailyGymHours: DailyGymHours) -> String {
        let openTime = dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }

        return ""
    }
}

// MARK: - Delegation
protocol WeekDelegate: class {
    func didChangeDay(day: WeekDay)
}

extension GymDetailTimeInfoView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        selectedDayIndex = day.index - 1
        updateAppearence()
    }
}