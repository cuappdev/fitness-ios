//
//  GymDetailPopularTimesCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailPopularTimesCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let popularTimesHistogramView = PopularTimesHistogramView()
    private let popularTimesLabel = UILabel()
    private let dividerView = UIView()

    // MARK: - Private data vars
    private var data: [Int] = []
    private var isOpen: Bool = true
    private var todaysHours: DailyGymHours!

    // MARK: - Constraint constants
    enum Constants {
        static let popularTimesHistogramHeight: CGFloat = 166
        static let popularTimesHistogramTopPadding: CGFloat = 24
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym, selectedPopularTimeIndex: Int, onChangeIndex: ((Int) -> Void)?) {
        data = gym.popularTimesList[Date().getIntegerDayOfWeekToday()]
        isOpen = gym.isOpen
        todaysHours = gym.gymHoursToday

        popularTimesHistogramView.configure(for: gym,
                                            selectedPopularTimeIndex: selectedPopularTimeIndex,
                                            onChangeIndex: onChangeIndex)
    }

    // MARK: - Private helpers
    private func setupViews() {
        popularTimesLabel.text = ClientStrings.GymDetail.popularHoursSection
        popularTimesLabel.font = ._16MontserratBold
        popularTimesLabel.textColor = .primaryBlack
        popularTimesLabel.textAlignment = .center
        contentView.addSubview(popularTimesLabel)

        contentView.addSubview(popularTimesHistogramView)

        dividerView.backgroundColor = .gray01
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let popularTimesHistogramHorizontalPadding = 18

        popularTimesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constraints.verticalPadding)
            make.height.equalTo(Constraints.titleLabelHeight)
        }

        popularTimesHistogramView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(popularTimesHistogramHorizontalPadding)
            make.top.equalTo(popularTimesLabel.snp.bottom).offset(Constants.popularTimesHistogramTopPadding)
            make.height.equalTo(Constants.popularTimesHistogramHeight)
        }

        dividerView.snp.makeConstraints { make in
            make.top.equalTo(popularTimesHistogramView.snp.bottom).offset(Constraints.verticalPadding)
            make.height.equalTo(Constraints.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
