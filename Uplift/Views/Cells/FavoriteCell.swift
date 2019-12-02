//
//  FavoriteCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    // MARK: Private View Vars
    private let cellBackground = UIView()
    private let favoriteLabel = UILabel()
    private let favoritedBackground = UIView()
    private let favoritedIcon = UIImageView()

    private let checkSize: CGFloat = 24
    private let checkBorderWidth: CGFloat = 1
    private let leftPadding: CGFloat = 15
    private let rightPadding: CGFloat = 16

    private var usesStars = false
    private var updateAppearence: ((Bool) -> Void)?

    private var picked = false

    // MARK: Public View Vars
    var currentlySelected: Bool {
        get { return picked }
    }

    // Reuse Identfier
    static let identifier = "favoriteCellIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white

        cellBackground.backgroundColor =  .primaryWhite
        cellBackground.layer.cornerRadius = 6
        cellBackground.layer.borderWidth = checkBorderWidth
        cellBackground.layer.borderColor = UIColor.gray01.cgColor
        cellBackground.layer.shadowOpacity = 0.125
        cellBackground.layer.shadowRadius = 6
        cellBackground.layer.shadowOffset = CGSize(width: 1, height: 3)

        contentView.addSubview(cellBackground)

        favoriteLabel.font = ._16MontserratMedium
        favoriteLabel.textColor = .upliftMediumGrey
        cellBackground.addSubview(favoriteLabel)

        favoritedBackground.tintColor = .primaryWhite
        favoritedBackground.layer.borderColor = UIColor.upliftMediumGrey.cgColor
        favoritedBackground.layer.borderWidth = 0
        favoritedBackground.layer.cornerRadius = checkSize / 2
        cellBackground.addSubview(favoritedBackground)

        favoritedIcon.image = UIImage(named: ImageNames.greenCheckmark)
        favoritedIcon.contentMode = .scaleAspectFit
        favoritedBackground.addSubview(favoritedIcon)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with gymName: String, displaysClasses: Bool) {
        usesStars = displaysClasses

        if usesStars {
            favoritedIcon.alpha = 0.4
            favoritedIcon.image = UIImage(named: ImageNames.starOutlineDark)
            updateAppearence = { currentlySelected in
                self.favoriteLabel.textColor = currentlySelected ? .primaryBlack : .upliftMediumGrey
                self.favoritedIcon.alpha = currentlySelected ? 1 : 0.4
                self.favoritedIcon.image = UIImage(named: currentlySelected ? ImageNames.starFilledInDark : ImageNames.starOutlineDark)
            }
        } else {
            favoritedIcon.isHidden = true
            favoritedIcon.image = UIImage(named: ImageNames.greenCheckmark)
            favoritedBackground.layer.borderWidth = checkBorderWidth
            updateAppearence = { currentlySelected in
                self.favoriteLabel.textColor = currentlySelected ? .primaryBlack : .upliftMediumGrey
                self.favoritedIcon.isHidden = !currentlySelected
                self.favoritedBackground.layer.borderWidth = currentlySelected ? 0 : self.checkBorderWidth
            }
        }

        favoriteLabel.text = gymName
    }

    func setUpConstraints() {
        cellBackground.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        favoriteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.centerY.equalToSuperview()
        }

        favoritedBackground.snp.makeConstraints { make in
            make.size.equalTo(checkSize)
            make.trailing.equalToSuperview().inset(rightPadding)
            make.centerY.equalToSuperview()
        }

        favoritedIcon.snp.makeConstraints { make in
            make.size.equalTo(checkSize + 1)
            make.center.equalToSuperview()
        }
    }

    func toggleSelectedView(selected: Bool) {
        picked = selected
        updateAppearence?(currentlySelected)
    }

}
