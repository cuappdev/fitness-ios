//
//  GymnasiumCollectionViewCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymnasiumCollectionViewCell: UICollectionViewCell {

    // MARK: - Private data vars
    private var facilityDetail: FacilityDetail!
    private var dailyGymHours: [DailyGymHours] = []
    private var selectedDayIndex = 0

    // MARK: Private view vars
    private let courtsCollectionView: UICollectionView
    private var facilityHoursRanges: [FacilityHoursRange] = []

    // MARK: Display
    private let courtSize = CGSize(width: 124, height: 192)

    override init(frame: CGRect) {
        let flowLayout = UICollectionViewFlowLayout()
        courtsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: frame)

        backgroundColor = .primaryWhite

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = -1 // Overlap Center Court Line
        flowLayout.itemSize = courtSize

        courtsCollectionView.backgroundColor = .primaryWhite
        courtsCollectionView.isUserInteractionEnabled = false
        courtsCollectionView.allowsSelection = false
        courtsCollectionView.isScrollEnabled = false
        courtsCollectionView.register(CourtCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.courtCollectionViewCell)
        courtsCollectionView.dataSource = self
        contentView.addSubview(courtsCollectionView)

        courtsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateCourtsDisplay(for day: Int) {
        let hours = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        // Restrictions describe court
        facilityHoursRanges = hours.flatMap { $0.timeRanges }
            .filter { !$0.restrictions.isEmpty }

        centerCollectionView()
        courtsCollectionView.reloadData()
    }

    // MARK: - Helper
    /// Creates insets so collection view displays its contents in the center
    private func centerCollectionView() {
        let numberCourtsDisplayed = CGFloat(facilityHoursRanges.count)
        let inset = (frame.width - (courtSize.width * numberCourtsDisplayed)) / 2
        courtsCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    // MARK: - Collection View Related
    func configure(facilityHoursRanges: [FacilityHoursRange], dailyGymHours: [DailyGymHours]) {
        self.facilityHoursRanges = facilityHoursRanges
        self.dailyGymHours = dailyGymHours
        centerCollectionView()
        courtsCollectionView.reloadData()
    }

    static func getHeight() -> CGFloat {
        return 192 // Same as courtSize height
    }

}

// MARK: - UICollectionViewDataSource
extension GymnasiumCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilityHoursRanges.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.courtCollectionViewCell, for: indexPath) as? CourtCollectionViewCell else { return UICollectionViewCell() }
        let facilityHoursRange = facilityHoursRanges[indexPath.row]
        cell.configure(
            facilityHoursRange: facilityHoursRange,
            dailyGymHours: dailyGymHours.filter { $0.dayOfWeek == selectedDayIndex },
            courtIndex: indexPath.row
        )
        return cell
    }

}

// MARK: - Delegation
extension GymnasiumCollectionViewCell: WeekDelegate {

    func weekDidChange(with day: WeekDay) {
        selectedDayIndex = day.index - 1
        updateCourtsDisplay(for: selectedDayIndex)
    }

}
