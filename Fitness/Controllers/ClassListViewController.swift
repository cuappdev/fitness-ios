//
//  ClassListViewController.swift
//  Fitness
//
//  Created by Austin Astorga on 10/09/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Crashlytics
import SnapKit
import UIKit

struct FilterParameters {
    var classNames: [String]
    var endTime: Date
    var gymIds: [String]
    var instructorNames: [String]
    var shouldFilter: Bool
    var startTime: Date
    var tags: [String]

    init(classNames: [String] = [],
         endTime: Date = Date(),
         gymIds: [String] = [],
         instructorNames: [String] = [],
         shouldFilter: Bool = false,
         startTime: Date = Date(),
         tags: [String] = []) {
        self.classNames = classNames
        self.endTime = endTime
        self.gymIds = gymIds
        self.instructorNames = instructorNames
        self.shouldFilter = shouldFilter
        self.startTime = startTime
        self.tags = tags
    }

}

class ClassListViewController: UIViewController {

    // MARK: - Private view vars
    private var calendarCollectionView: UICollectionView!
    private var classCollectionView: UICollectionView!
    private var filterButton: UIButton!
    private var titleLabel: UILabel!
    private var titleView: UIView!

    private var noClassesEmptyStateView: NoClassesEmptyStateView!
    private var noResultsEmptyStateView: NoResultsEmptyStateView!

    // MARK: - Private data vars
    private var calendarDatesList: [Date] = []
    private var classList: [[GymClassInstance]] = Array.init(repeating: [], count: 10)
    private var currentFilterParams: FilterParameters?
    private var filteredClasses: [GymClassInstance] = []
    private var filteringIsActive = false
    lazy private var calendarDateSelected: Date = {
        return currDate
    }()

    private let cal = Calendar.current
    private var currDate: Date!

    private enum Constants {
        static let calendarCellIdentifier = "calendarCellIdentifier"
        static let classListHeaderViewIdentifier = "classListHeaderViewIdentifier"
        static let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        calendarDatesList = createCalendarDates()
        // Set currDate to be today's date
        currDate = calendarDatesList[3]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        setupViews()
        setupConstraints()

        getClassesFor(date: calendarDateSelected)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Update filtering
        if let params = currentFilterParams {
            filterOptions(params: params)
        }
    }

    // MARK: - Public methods
    func updateCalendarDateSelectedToToday() {
        // Set the calendarDateSelected to be today
        calendarDateSelected = calendarDatesList[3]
        calendarCollectionView.reloadData()
        getClassesFor(date: calendarDateSelected)
        if currentFilterParams != nil {
            filterOptions(params: FilterParameters())
        }
    }

    // MARK: - Targets
    @objc func filterPressed() {
        let filterVC = FilterViewController(currentFilterParams: currentFilterParams)
        filterVC.delegate = self
        let filterNavController = UINavigationController(rootViewController: filterVC)
        tabBarController?.present(filterNavController, animated: true, completion: nil)
    }

    // MARK: - Private methods

    /// Get a list of dates starting from 3 days before today and ending 6 days after today
    private func createCalendarDates() -> [Date] {
        let cal = Calendar.current
        let currDate = Date()

        guard let startDate = cal.date(byAdding: .day, value: -3, to: currDate) else { return  [] }
        guard let endDate = cal.date(byAdding: .day, value: 6, to: currDate) else { return [] }

        var dateList: [Date] = []
        var date = startDate
        while date <= endDate {
            dateList.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date) ?? Date()
        }

        return dateList
    }

    /// Get the list of classes for [date] and update classCollectionView with those classes.
    private func getClassesFor(date: Date) {
        guard let index = self.calendarDatesList.firstIndex(of: date) else { return }

        if classList[index].isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: date)) { [weak self] classes in
                guard let strongSelf = self else { return }

                strongSelf.classList[index] = classes
                strongSelf.updateClassCollectionViewWithFilters()
            }
            return
        }

        updateClassCollectionViewWithFilters()
    }

    /// Update classCollectionView with the current filters
    private func updateClassCollectionViewWithFilters() {
        if let filterParams = self.currentFilterParams {
            self.filterOptions(params: filterParams)
        } else {
            self.classCollectionView.reloadData()
        }
    }
}

extension ClassListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView {
            guard let indexOfSelectedDate = calendarDatesList.firstIndex(of: calendarDateSelected) else { return 0 }

            let selectedDaysClasses = classList[indexOfSelectedDate]
            let selectedDayHasNoClasses = selectedDaysClasses.isEmpty
            let filteredClassesIsEmpty = filteringIsActive && filteredClasses.isEmpty
            noClassesEmptyStateView.isHidden = !selectedDayHasNoClasses
            noResultsEmptyStateView.isHidden = !(filteredClassesIsEmpty && !selectedDayHasNoClasses)

            if filteringIsActive {
                return filteredClasses.count
            }

            return selectedDaysClasses.count
        }

        if collectionView == calendarCollectionView {
            return calendarDatesList.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.calendarCellIdentifier, for: indexPath) as! CalendarCell
            let dateForCell = calendarDatesList[indexPath.item]
            let dayOfWeek = cal.component(.weekday, from: dateForCell) - 1
            let dayOfMonth = cal.component(.day, from: dateForCell)

            var dateLabelCircleIsHidden = true
            var dateLabelFont = UIFont._12MontserratRegular
            var dateLabelTextColor: UIColor?
            var dayOfWeekLabelFont = UIFont._12MontserratRegular
            var dayOfWeekLabelTextColor: UIColor?

            if dateForCell < currDate {
                dateLabelTextColor = .fitnessMediumGrey
                dayOfWeekLabelTextColor = .fitnessMediumGrey
            }

            if dateForCell == calendarDateSelected {
                dateLabelCircleIsHidden = false
                dateLabelFont = ._12MontserratSemiBold
                dateLabelTextColor = .white
                dayOfWeekLabelFont = ._12MontserratSemiBold
            }

            cell.configure(for: "\(dayOfMonth)",
                dateLabelTextColor: dateLabelTextColor,
                dateLabelFont: dateLabelFont!,
                dayOfWeekLabelText: Constants.daysOfWeek[dayOfWeek],
                dayOfWeekLabelTextColor: dayOfWeekLabelTextColor,
                dayOfWeekLabelFont: dayOfWeekLabelFont!,
                dateLabelCircleIsHidden: dateLabelCircleIsHidden
            )
            return cell
        }

        guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return UICollectionViewCell() }
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        let gymClassInstance = filteringIsActive ? filteredClasses[indexPath.item] : classList[index][indexPath.item]
        cell.configure(gymClassInstance: gymClassInstance, style: .date)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            calendarDateSelected = calendarDatesList[indexPath.item]
            calendarCollectionView.reloadData()
            getClassesFor(date: calendarDateSelected)
        } else if collectionView == classCollectionView {
            guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }
            let gymClassInstance = filteringIsActive ? filteredClasses[indexPath.row] : classList[index][indexPath.row]
            let classDetailViewController = ClassDetailViewController(gymClassInstance: gymClassInstance)
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == classCollectionView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.classListHeaderViewIdentifier, for: indexPath) as! ClassListHeaderView

            var titleLabelText = "TODAY"
            if currDate != calendarDateSelected {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                titleLabelText = dateFormatter.string(from: calendarDateSelected)
            }
            headerView.configure(with: titleLabelText)
            return headerView
        }

        return UICollectionReusableView()
    }

}

// MARK: - Filtering Delegate
extension ClassListViewController: FilterDelegate {

    func filterOptions(params: FilterParameters) {

        filteringIsActive = params.shouldFilter

        if filteringIsActive {
            currentFilterParams = params

            // Modify Button
            filterButton.backgroundColor = .fitnessYellow
            filterButton.setTitle("APPLIED FILTER", for: .normal)

            // MARK: - Fabric
            Answers.logCustomEvent(withName: "Applied Filters")
        } else {
            currentFilterParams = nil

            // Modify Button
            filterButton.backgroundColor = .white
            filterButton.setTitle("APPLY FILTER", for: .normal)
            classCollectionView.reloadData()
            return
        }

        // Get the difference in days between startTime and calendarDateSelected
        let offset = Int(calendarDateSelected.timeIntervalSince(params.startTime) / Date.secondsPerDay)
        var components =  DateComponents()
        components.day = offset

        // Get the adjustedStart and adjustedEnd times
        let adjustedStart = cal.date(byAdding: components, to: params.startTime) ?? params.startTime
        let adjustedEnd = cal.date(byAdding: components, to: params.endTime) ?? params.endTime

        guard let indexOfSelectedDate = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }

        // Get the list of valid classes that are in between the adjustedStart and adjustedEnd times
        filteredClasses = classList[indexOfSelectedDate].filter { currClass in
            guard currClass.startTime >= adjustedStart, currClass.endTime <= adjustedEnd else { return false }

            if !params.gymIds.isEmpty {
                guard params.gymIds.contains(currClass.gymId) else { return false }
            }
            if !params.classNames.isEmpty {
                guard params.classNames.contains(currClass.className) else { return false }
            }

            if !params.instructorNames.isEmpty {
                guard params.instructorNames.contains(currClass.instructor) else { return false }
            }

            if !params.tags.isEmpty {
                guard (currClass.tags.contains { tag in
                    return params.tags.contains(tag.name)}) else { return false }
            }

            return true
        }

        // Reload classCollectionView with updated filteredClasses
        classCollectionView.reloadData()
    }
}

// MARK: - Layout
extension ClassListViewController {

    private func setupViews() {
        setupCollectionViews()

        titleView = UIView()
        titleView.backgroundColor = .white
        titleView.layer.shadowOffset = CGSize(width: 0, height: 9)
        titleView.layer.shadowColor = UIColor.buttonShadow.cgColor
        titleView.layer.shadowOpacity = 0.25
        titleView.clipsToBounds = false
        view.addSubview(titleView)

        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Classes"
        titleView.addSubview(titleLabel)

        noClassesEmptyStateView = NoClassesEmptyStateView()
        view.addSubview(noClassesEmptyStateView)

        noResultsEmptyStateView = NoResultsEmptyStateView()
        view.addSubview(noResultsEmptyStateView)

        filterButton = UIButton()
        filterButton.setTitle("APPLY FILTER", for: .normal)
        filterButton.titleLabel?.font = ._14MontserratSemiBold
        filterButton.layer.cornerRadius = 24.0
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        filterButton.layer.shadowColor = UIColor.fitnessBlack.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 2.0
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.masksToBounds = false
        view.addSubview(filterButton)
    }

    private func setupConstraints() {
        let calendarCollectionViewHeight = 47
        let calendarCollectionViewTopPadding = 40
        let classCollectionViewTopPadding = 18
        let filterButtonBottomPadding = 36
        let filterButtonSize = CGSize(width: 180, height: 48)
        let titleBottomConstant = -20
        let titleHeightConstant = 26
        let titleLeadingConstant = 24
        let titleViewHeightConstant = 120

        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(titleViewHeightConstant)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLeadingConstant)
            make.bottom.equalToSuperview().offset(titleBottomConstant)
            make.height.equalTo(titleHeightConstant)
            make.trailing.lessThanOrEqualTo(titleView)
        }

        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(calendarCollectionViewTopPadding)
            make.height.equalTo(calendarCollectionViewHeight)
            make.leading.trailing.equalToSuperview()
        }

        classCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarCollectionView.snp.bottom).offset(classCollectionViewTopPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }

        noClassesEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(classCollectionView)
        }

        noResultsEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(classCollectionView)
        }

        filterButton.snp.makeConstraints { make in
            make.size.equalTo(filterButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(filterButtonBottomPadding)
            make.centerX.equalToSuperview()
        }
    }

    private func setupCollectionViews() {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarFlowLayout)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: Constants.calendarCellIdentifier)
        view.addSubview(calendarCollectionView)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.frame.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: view.frame.width - 32.0, height: 72.0)

        classCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.contentInset = .init(top: 0.0, left: 0.0, bottom: 84.0, right: 0.0)
        classCollectionView.backgroundColor = .white
        classCollectionView.delaysContentTouches = false
        classCollectionView.register(ClassListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.classListHeaderViewIdentifier)
        classCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        view.addSubview(classCollectionView)
    }

}
