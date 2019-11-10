//
//  PopularTimesHistogramView.swift
//  Uplift
//
//  Created by Kevin Chan on 11/6/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import AppDevHistogram
import UIKit

class PopularTimesHistogramView: UIView {

    // MARK: - Public data vars
    var onChangeIndex: ((Int) -> Void)?

    // MARK: - Private view vars
    private let histogramView = HistogramView()

    // MARK: - Private data vars
    private var busynessRatings: [Int] = (0..<24).map({ $0 })

    private let overflowedEndHour = 24
    private let startHour = 6 // Start displaying hours from 6am onwards
    private let todaysDate = Date()
    private let busynessLevelDescriptors = [
        ClientStrings.Histogram.busynessLevel1,
        ClientStrings.Histogram.busynessLevel2,
        ClientStrings.Histogram.busynessLevel3
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)

        histogramView.dataSource = self
        histogramView.delegate = self
        addSubview(histogramView)

        let histogramViewHeight = 166
        histogramView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(histogramViewHeight)
        }
    }

    // MARK: - Public configure
    func configure(for gym: Gym, selectedPopularTimeIndex: Int, onChangeIndex: ((Int) -> Void)?) {
        busynessRatings = gym.popularTimesList[todaysDate.getIntegerDayOfWeekToday()]
        self.onChangeIndex = onChangeIndex

        DispatchQueue.main.async {
            self.histogramView.reloadData()

            self.histogramView.selectBar(at: selectedPopularTimeIndex, animated: false, generateFeedback: false, force: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PopularTimesHistogramView: HistogramViewDataSource {

    func numberOfDataPoints(for histogramView: HistogramView) -> Int {
        return overflowedEndHour - startHour
    }

    func histogramView(_ histogramView: HistogramView, relativeValueOfDataPointAt index: Int) -> Double {
        let maxBusynessRating = Double(busynessRatings.max() ?? 1)
        return Double(busynessRatings[getBusynessRatingsIndex(for: index)]) / maxBusynessRating
    }

    func histogramView(_ histogramView: HistogramView, descriptionForDataPointAt index: Int) -> NSAttributedString? {
        guard let startHourDate = Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: todaysDate) else { return nil }

        let secondsPerHour: Double = 3600.0
        let numSecondsPastStartHour = Double(index) * secondsPerHour

        // Get hour of day, i.e. "12p"
        let hourOfDay = startHourDate.addingTimeInterval(numSecondsPastStartHour)
            .getStringOfDatetime(format: "ha")

        // Get busyness rating, i.e. "A little busy"
        let busynessLevelRating = getBusynessLevelDescriptor(for: index)

        let attributedString = NSMutableAttributedString(
            string: "\(hourOfDay) : \(busynessLevelRating)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray04]
        )
        attributedString.addAttributes(
            [NSAttributedString.Key.font: UIFont._12MontserratBold as Any],
            range: NSRange(location: 0, length: hourOfDay.count + 2)
        )
        attributedString.addAttributes(
            [NSAttributedString.Key.font: UIFont._12MontserratMedium as Any],
            range: NSRange(location: hourOfDay.count + 3, length: busynessLevelRating.count)
        )
        return attributedString
    }

    func numberOfDataPointsPerTickMark(for histogramView: HistogramView) -> Int? {
        return 3
    }

    func histogramView(_ histogramView: HistogramView, titleForTickMarkAt index: Int) -> String? {
        let tickHour = containOverflowedMilitaryHour(hour: startHour + index)
        return formattedHourForTime(militaryHour: tickHour)
    }

    func font(for histogramView: HistogramView) -> UIFont {
        return UIFont._14MontserratSemiBold ?? UIFont._14SFSemibold
    }

    func defaultBarColor(for histogramView: HistogramView) -> UIColor {
        return .primaryLightYellow
    }

    func highlightedBarColor(for histogramView: HistogramView) -> UIColor {
        return .primaryYellow
    }

    // MARK: - Private helpers
    private func getBusynessLevelDescriptor(for index: Int) -> String {
        let highThreshold = 57
        let mediumThreshold = 25
        let busynessRating = busynessRatings[getBusynessRatingsIndex(for: index)]

        if busynessRating < mediumThreshold {
            return busynessLevelDescriptors[0]
        } else if busynessRating < highThreshold {
            return busynessLevelDescriptors[1]
        } else {
            return busynessLevelDescriptors[2]
        }
    }

    private func getBusynessRatingsIndex(for index: Int) -> Int {
        // We start displaying hours from 6am rather than 12am so we need to add 6
        return (index + 6) % 24
    }

    /// Overflowed military hour is a time between 0...47
    private func containOverflowedMilitaryHour(hour: Int) -> Int {
        return (hour >= 24) ? hour - 24 : hour
    }

    private func formattedHourForTime(militaryHour: Int) -> String {
        var formattedHour: String!
        if militaryHour > 12 {
            formattedHour = "\(militaryHour - 12)p"
        } else if militaryHour == 12 {
            formattedHour = "12p"
        } else if militaryHour > 0 {
            formattedHour = "\(militaryHour)a"
        } else {
            formattedHour = "12a"
        }
        return formattedHour
    }

}

extension PopularTimesHistogramView: HistogramViewDelegate {

    func histogramView(_ histogramView: HistogramView, didChangeIndex index: Int) {
        onChangeIndex?(index)
    }

}
