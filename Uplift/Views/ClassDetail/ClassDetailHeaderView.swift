//
//  ClassDetailHeaderView.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailHeaderViewDelegate: class {
    func classDetailHeaderViewBackButtonTapped()
    func classDetailHeaderViewFavoriteButtonTapped()
    func classDetailHeaderViewInstructorSelected()
    func classDetailHeaderViewLocationSelected()
    func classDetailHeaderViewShareButtonTapped()
}

class ClassDetailHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let backButton = UIButton()
    private let imageView = UIImageView()
    private let imageFilterView = UIView()
    private let semicircleImageView = UIImageView(image: UIImage(named: ImageNames.semicircle))
    private let titleLabel = UILabel()
    private let locationButton = UIButton()
    private let instructorButton = UIButton()
    private let durationLabel = UILabel()
    private let favoriteButton = UIButton()
    private let shareButton = UIButton()

    // MARK: - Private data vars
    private weak var delegate: ClassDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ClassDetailHeaderViewDelegate, gymClassInstance: GymClassInstance) {
        self.delegate = delegate
        imageView.kf.setImage(with: gymClassInstance.imageURL)
        titleLabel.text = gymClassInstance.className.uppercased()
        locationButton.setTitle(gymClassInstance.location, for: .normal)
        instructorButton.setTitle(gymClassInstance.instructor.uppercased(), for: .normal)
        durationLabel.text = String(Int(gymClassInstance.duration) / 60) + ClientStrings.ClassDetail.durationMin
    }

    func selectFavoriteButton() {
        favoriteButton.isSelected = true
    }

    func deselectFavoriteButton() {
        favoriteButton.isSelected = false
    }

    // MARK: - Targets
    @objc func backButtonTapped() {
        delegate?.classDetailHeaderViewBackButtonTapped()
    }

    @objc func locationSelected() {
        delegate?.classDetailHeaderViewLocationSelected()
    }

    @objc func instructorSelected() {
        delegate?.classDetailHeaderViewInstructorSelected()
    }

    @objc func favoriteButtonTapped() {
        delegate?.classDetailHeaderViewFavoriteButtonTapped()
    }

    @objc func shareButtonTapped() {
        delegate?.classDetailHeaderViewShareButtonTapped()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        backButton.setImage(UIImage(named: ImageNames.lightBackArrow), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addSubview(backButton)

        favoriteButton.setImage(UIImage(named: ImageNames.whiteStarOutline), for: .normal)
        favoriteButton.setImage(UIImage(named: ImageNames.yellowWhiteStar), for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        addSubview(favoriteButton)

        shareButton.setImage(UIImage(named: ImageNames.lightShare), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        addSubview(shareButton)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(imageFilterView)

        semicircleImageView.contentMode = UIView.ContentMode.scaleAspectFit
        semicircleImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(semicircleImageView)

        titleLabel.font = ._48Bebas
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primaryWhite
        addSubview(titleLabel)

        locationButton.setTitleColor(.primaryWhite, for: .normal)
        locationButton.titleLabel?.font = ._14MontserratRegular
        locationButton.titleLabel?.textAlignment = .center
        locationButton.addTarget(self, action: #selector(locationSelected), for: .touchUpInside)
        addSubview(locationButton)

        instructorButton.titleLabel?.font = ._16MontserratBold
        instructorButton.titleLabel?.textAlignment = .center
        instructorButton.setTitleColor(.primaryWhite, for: .normal)
        instructorButton.addTarget(self, action: #selector(instructorSelected), for: .touchUpInside)
        addSubview(instructorButton)

        durationLabel.font = ._14MontserratBold
        durationLabel.textAlignment = .center
        durationLabel.textColor = .primaryBlack
        addSubview(durationLabel)

        bringSubviewToFront(backButton)
        bringSubviewToFront(favoriteButton)
        bringSubviewToFront(shareButton)
    }

    private func setupConstraints() {
        let durationLabelBottomPadding = 5
        let durationLabelSize = CGSize(width: 52, height: 18)
        let instructorButtonHeight = 21
        let instructorButtonTopPadding = 20
        let locationButtonHeight = 16
        let semicircleImageViewSize = CGSize(width: 100, height: 50)
        let titleLabelHorizontalPadding = 40
        let buttonOuterSidePadding = 20
        let buttonSize = CGSize(width: 24, height: 24)
        let backButtonTopPadding = 47
        let shareButtonRightPadding = 14

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(buttonOuterSidePadding)
            make.top.equalToSuperview().offset(backButtonTopPadding)
            make.size.equalTo(buttonSize)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-buttonOuterSidePadding)
            make.centerY.equalTo(backButton.snp.centerY)
            make.size.equalTo(buttonSize)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-shareButtonRightPadding)
            make.centerY.equalTo(favoriteButton.snp.centerY)
            make.size.equalTo(buttonSize)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        semicircleImageView.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(semicircleImageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(titleLabelHorizontalPadding)
            make.center.equalToSuperview()
        }

        locationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(locationButtonHeight)
        }

        instructorButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(locationButton.snp.bottom).offset(instructorButtonTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(instructorButtonHeight)
        }

        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-durationLabelBottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(durationLabelSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
