//
//  ProfileView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/1/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class ProfileView: UIView {

    // MARK: - Views
    private let collectionView: UICollectionView!
    private let gamesPlayedLabel = UILabel()
    private let nameLabel = UILabel()
    private let profilePicture = UIImageView(frame: .zero)

    let collectionViewLeftRightInset: CGFloat = 24
    let gamesSections: [GamesListHeaderSections] = [.myGames, .joinedGames, .pastGames]
    let profilePictureSize: CGFloat = 60

    // MARK: - Data
    var myGames: [Post] = []
    var joinedGames: [Post] = []
    var pastGames: [Post] = []

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        backgroundColor = .white

        profilePicture.image = UIImage(named: ImageNames.profilePicDemo)
        profilePicture.layer.cornerRadius = profilePictureSize
        addSubview(profilePicture)

        nameLabel.text = "Zain Khoja"
        nameLabel.font = ._24MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        addSubview(nameLabel)

        gamesPlayedLabel.text = "27 games played"
        gamesPlayedLabel.font = ._14MontserratMedium
        gamesPlayedLabel.textAlignment = .center
        gamesPlayedLabel.textColor = .gray04
        addSubview(gamesPlayedLabel)

        collectionView.register(PickupGameCell.self, forCellWithReuseIdentifier: Identifiers.pickupGameCell)
        collectionView.register(GamesListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.gamesListHeaderView)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 13.4, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        let gamesPlayedLabelTopOffset = 4
        let nameLabelTopOffset = 12
        let profilePictureTopOffset = 68

        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(profilePictureTopOffset)
            make.height.width.equalTo(profilePictureSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.bottom).offset(nameLabelTopOffset)
            make.centerX.equalToSuperview()
        }

        gamesPlayedLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(gamesPlayedLabelTopOffset)
            make.centerX.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(gamesPlayedLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func showGameCellDayLabel(for indexPath: IndexPath) -> Bool {
        var postsArray: [Post]
        switch gamesSections[indexPath.section] {
        case .myGames:
            postsArray = myGames
        case .joinedGames:
            postsArray = joinedGames
        case .pastGames:
            postsArray = pastGames
        }
        let post = postsArray[indexPath.row]

        // Show the cell's day label if the game is the first in its section, or is on a different day than the previous game in its section
        return indexPath.row == 0 ? true : !Calendar.current.isDate(post.time, inSameDayAs: postsArray[indexPath.row - 1].time)
    }

}

extension ProfileView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gamesSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch gamesSections[section] {
        case .myGames:
            return myGames.count
        case .joinedGames:
            return joinedGames.count
        case .pastGames:
            return pastGames.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let gameSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.gamesListHeaderView, for: indexPath) as! GamesListHeaderView
        gameSectionHeader.configure(for: gamesSections[indexPath.section])
        return gameSectionHeader
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.pickupGameCell, for: indexPath) as! PickupGameCell
        var postsArray: [Post]
        switch gamesSections[indexPath.section] {
        case .myGames:
            postsArray = myGames
        case .joinedGames:
            postsArray = joinedGames
        case .pastGames:
            postsArray = pastGames
        }
        cell.configure(for: postsArray[indexPath.row], showDayLabel: showGameCellDayLabel(for: indexPath))
        return cell
    }

}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 2 * collectionViewLeftRightInset, height: GamesListHeaderView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = showGameCellDayLabel(for: indexPath) ? PickupGameCell.heightShowingDayLabel : PickupGameCell.height
        return CGSize(width: collectionView.bounds.width - 2 * collectionViewLeftRightInset, height: height)
    }

}