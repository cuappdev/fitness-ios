//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit

class GymsCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    var colorBar: UIView!
    var locationName: UILabel!
    var hours: UILabel!
    var status: UILabel!
    var shadowView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        //BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        //SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 0, left: 0, bottom: 9, right: -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

        //YELLOW BAR
        colorBar = UIView()
        colorBar.backgroundColor = .fitnessYellow
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 5
        colorBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.addSubview(colorBar)

        //LOCATION NAME
        locationName = UILabel()
        locationName.font = ._12MontserratMedium
        locationName.sizeToFit()
        contentView.addSubview(locationName)

        //STATUS
        status = UILabel()
        status.font = ._8MontserratMedium
        contentView.addSubview(status)

        //HOURS
        hours = UILabel()
        hours.font = ._8MontserratMedium
        hours.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        contentView.addSubview(hours)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        colorBar.snp.updateConstraints {make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(32)
        }

        locationName.snp.updateConstraints {make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-23)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-26)
        }

        status.snp.updateConstraints {make in
            make.left.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(28)
        }

        hours.snp.updateConstraints {make in
            make.left.equalTo(status.snp.right).offset(5)

            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(28)
        }
    }
}
