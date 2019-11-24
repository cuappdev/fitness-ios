//
//  GymDetailViewController.swift
//  Uplift
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Crashlytics
import UIKit

class GymDetailViewController: UIViewController {

    // MARK: - Public view vars
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())

    // MARK: - Private data vars
    private var equipment: [EquipmentCategory] = []
    private var sections: [Section] = []
    // Default index is current hour subtracted by 6 because popular times histogram
    // view displays hours starting from 6am
    private var selectedPopularTimeIndex = Calendar.current.component(.hour, from: Date()) - 6
    private var todaysClasses: [GymClassInstance] = []

    // MARK: - Public data vars
    var gymDetail: GymDetail!

    private enum Constants {
        static let gymDetailClassesCellIdentifier = "gymDetailClassesCellIdentifier"
        static let gymDetailFacilitiesCellIdentifier = "gymDetailFacilitiesCellIdentifier"
        static let gymDetailHeaderViewIdentifier = "gymDetailHeaderViewIdentifier"
        static let gymDetailHoursCellIdentifier = "gymDetailHoursCellIdentifier"
        static let gymDetailPopularTimesCellIdentifier = "gymDetailPopularTimesCellIdentifier"
    }

    // MARK: - Private classes/enums
    private struct Section {
        var items: [ItemType]
    }

    private enum ItemType {
        case busyTimes
        case classes([GymClassInstance])
        case facilities
        case hours
    }

    // MARK: - Custom Initializer
    init(gym: Gym) {
        super.init(nibName: nil, bundle: nil)
        self.gymDetail = GymDetail(gym: gym)

        for facility in gymDetail.facilities where facility.name == "Fitness Center" {
            self.equipment = categorizeEquipment(equipmentList: facility.details[0].equipment)
        }

        if gym.isOpen {
            self.sections = [
                Section(items: [.hours, .busyTimes, .facilities, .classes([])])
            ]
        } else {
            self.sections = [
                Section(items: [.hours, .facilities, .classes([])])
            ]
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white

        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Checking Gym Details")

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)

        setupViews()

        NetworkManager.shared.getClassInstancesByGym(gymId: gymDetail.gym.id, date: Date.getNowString()) { gymClasses in
            self.todaysClasses = gymClasses
            let items = self.sections[0].items
            self.sections[0].items[items.count - 1] = .classes(gymClasses)
            DispatchQueue.main.async {
                // Only reload the classes cell
                self.collectionView.reloadItems(at: [IndexPath(row: items.count - 1, section: 0)])
            }
        }

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Targets
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate, CollectionViewDelegateFlowLayout
extension GymDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = sections[indexPath.section].items[indexPath.item]

        switch itemType {
        case .hours:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailHoursCellIdentifier, for: indexPath) as! GymDetailHoursCell
            cell.configure(for: self, gymDetail: gymDetail)
            return cell
        case .busyTimes:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailPopularTimesCellIdentifier, for: indexPath) as! GymDetailPopularTimesCell
            cell.configure(for: gymDetail.gym, selectedPopularTimeIndex: selectedPopularTimeIndex) { index in
                self.selectedPopularTimeIndex = index
            }
            return cell
        case .facilities:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailFacilitiesCellIdentifier, for: indexPath) as! GymDetailFacilitiesCell
            cell.configure(for: gymDetail)
            return cell
        case .classes:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailClassesCellIdentifier, for: indexPath) as! GymDetailTodaysClassesCell
            cell.configure(for: self, classes: todaysClasses)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemType = sections[indexPath.section].items[indexPath.item]
        let width = collectionView.frame.width

        switch itemType {
        case .hours:
            return CGSize(width: width, height: getHoursHeight())
        case .busyTimes:
            return CGSize(width: width, height: getBusyTimesHeight())
        case.facilities:
            return CGSize(width: width, height: getFacilitiesHeight())
        case.classes:
            return CGSize(width: width, height: getTodaysClassesHeight())
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.gymDetailHeaderViewIdentifier,
            // swiftlint:disable:next force_cast
            for: indexPath) as! GymDetailHeaderView
        headerView.configure(for: self, for: gymDetail.gym)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 360)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    private func classesCollectionViewHeight() -> CGFloat {
        let cellPadding: CGFloat = 12
        let cellHeight: CGFloat = 100
        let numberOfClasses = CGFloat(todaysClasses.count)

        return numberOfClasses * cellHeight + (numberOfClasses - 1) * cellPadding
    }
}

// MARK: - Layout
extension GymDetailViewController {
    private func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GymDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.gymDetailHeaderViewIdentifier)
        collectionView.register(GymDetailHoursCell.self, forCellWithReuseIdentifier: Constants.gymDetailHoursCellIdentifier)
        collectionView.register(GymDetailPopularTimesCell.self, forCellWithReuseIdentifier: Constants.gymDetailPopularTimesCellIdentifier)
        collectionView.register(GymDetailFacilitiesCell.self, forCellWithReuseIdentifier: Constants.gymDetailFacilitiesCellIdentifier)
        collectionView.register(GymDetailTodaysClassesCell.self, forCellWithReuseIdentifier: Constants.gymDetailClassesCellIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Item Height Calculations
extension GymDetailViewController {
func getHoursHeight() -> CGFloat {
        let baseHeight = Constraints.verticalPadding +
            Constraints.titleLabelHeight +
            GymDetailHoursCell.Constants.hoursTableViewTopPadding +
            Constraints.verticalPadding +
            Constraints.dividerViewHeight

        let height = gymDetail.hoursDataIsDropped
            ? baseHeight + GymDetailHoursCell.Constants.hoursTableViewDroppedHeight
            : baseHeight + GymDetailHoursCell.Constants.hoursTableViewHeight
        return height
    }

    func getBusyTimesHeight() -> CGFloat {
        let labelHeight = Constraints.verticalPadding +
            Constraints.titleLabelHeight

        let histogramHeight =
        GymDetailPopularTimesCell.Constants.popularTimesHistogramTopPadding +
        GymDetailPopularTimesCell.Constants.popularTimesHistogramHeight

        let dividerHeight = Constraints.verticalPadding +
        Constraints.dividerViewHeight

        return labelHeight + histogramHeight + dividerHeight
    }

    func getFacilitiesHeight() -> CGFloat {
        let baseHeight = Constraints.verticalPadding +
            Constraints.titleLabelHeight +
            GymDetailFacilitiesCell.Constants.gymFacilitiesTopPadding +
            Constraints.verticalPadding +
            Constraints.dividerViewHeight

        let tableViewHeight = GymDetailFacilitiesCell.Constants.gymFacilitiesCellHeight *
                CGFloat(gymDetail.facilitiesList.count)

        return baseHeight + tableViewHeight
    }

    func getTodaysClassesHeight() -> CGFloat {
        let baseHeight = Constraints.verticalPadding +
            Constraints.titleLabelHeight

        let noMoreClassesHeight = GymDetailTodaysClassesCell.Constants.noMoreClassesLabelTopPadding +
            GymDetailTodaysClassesCell.Constants.noMoreClassesLabelHeight +
            Constraints.verticalPadding

        let collectionViewHeight = 2.0 * GymDetailTodaysClassesCell.Constants.classesCollectionViewVerticalPadding +
            classesCollectionViewHeight()

        return (todaysClasses.isEmpty) ? baseHeight + noMoreClassesHeight : baseHeight + collectionViewHeight
    }
}

extension GymDetailViewController {
    func categorizeEquipment(equipmentList: [Equipment]) -> [EquipmentCategory] {
        let equipmentDictionary = equipmentList.reduce(into: [String: [Equipment]](), { dict, equipment in
          if dict[equipment.equipmentType] != nil {
            dict[equipment.equipmentType]?.append(equipment)
          } else {
            dict[equipment.equipmentType] = [equipment]
          }
        })

        let equipmentCategories = equipmentDictionary.map { EquipmentCategory(categoryName: $0, equipment: $1) }

        return equipmentCategories
    }
}
