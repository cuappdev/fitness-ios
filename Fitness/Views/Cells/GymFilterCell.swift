//
//  GymFilterCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymFilterCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymFilterCell
    var gymNameLabel: UILabel!
    var selectedCircle: UIView!
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                gymNameLabel.font = ._14MontserratBold
                selectedCircle.backgroundColor = .fitnessYellow
            } else {
                gymNameLabel.font = ._14MontserratRegular
                selectedCircle.backgroundColor = .white
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        gymNameLabel = UILabel()
        gymNameLabel.font = ._14MontserratRegular
        gymNameLabel.textColor = .fitnessBlack
        gymNameLabel.sizeToFit()
        gymNameLabel.textAlignment = .center
        contentView.addSubview(gymNameLabel)

        selectedCircle = UIView()
        selectedCircle.clipsToBounds = true
        selectedCircle.layer.cornerRadius = 3
        selectedCircle.backgroundColor = .white
        contentView.addSubview(selectedCircle)

        isSelected = false

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        gymNameLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }

        selectedCircle.snp.updateConstraints { (make) in
            make.centerX.equalTo(gymNameLabel.snp.centerX)
            make.height.width.equalTo(6)
            make.top.equalTo(gymNameLabel.snp.bottom).offset(2)
        }
    }
}
