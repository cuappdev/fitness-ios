//
//  DropdownViewCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class DropdownViewCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.dropdownViewCell
    var titleLabel: UILabel!

    var checkBox: UIView!
    var checkBoxColoring: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white

        // TITLE LABEL
        titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = ._14MontserratLight
        titleLabel.textColor = .primaryBlack
        titleLabel.text = ""
        addSubview(titleLabel)

        // CHECKBOX
        checkBox = UIView()
        checkBox.layer.cornerRadius = 3
        checkBox.layer.borderColor = UIColor.gray04.cgColor
        checkBox.layer.borderWidth = 0.5
        checkBox.layer.masksToBounds = false
        addSubview(checkBox)

        checkBoxColoring = UIView()
        checkBoxColoring.backgroundColor = .white
        checkBoxColoring.layer.cornerRadius = 1
        checkBox.addSubview(checkBoxColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        setupConstraints()
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }

        checkBox.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-23)
            make.width.equalTo(20)
            make.bottom.equalToSuperview().offset(-10)
        }

        checkBoxColoring.snp.updateConstraints { make in
            make.top.leading.equalToSuperview().offset(3)
            make.bottom.trailing.equalToSuperview().offset(-3)
        }
    }
}
