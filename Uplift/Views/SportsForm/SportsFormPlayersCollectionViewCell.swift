//
//  SportsFormPlayersCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormPlayersCollectionViewCell: UICollectionViewCell {
    
    private let divider = UIView()
    private let headerLabel = UILabel()
    private let playersNeededLabel = UILabel()
    private let playersNeededTextField = UITextField()
    private let totalPlayersLabel = UILabel()
    private let totalPlayersTextField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.text = "PLAYERS"
        headerLabel.font = ._12MontserratBold
        headerLabel.textColor = .gray04
        contentView.addSubview(headerLabel)
        
        totalPlayersTextField.font = ._14MontserratMedium
        totalPlayersTextField.textColor = .primaryBlack
        totalPlayersTextField.placeholder = "10"
        totalPlayersTextField.delegate = self
        totalPlayersTextField.returnKeyType = .done
        totalPlayersTextField.keyboardType = .numberPad
        totalPlayersTextField.layer.borderColor = UIColor.gray01.cgColor
        totalPlayersTextField.layer.borderWidth = 1
        totalPlayersTextField.layer.cornerRadius = 5
        totalPlayersTextField.layer.masksToBounds = true
        totalPlayersTextField.textAlignment = .center
        contentView.addSubview(totalPlayersTextField)
        
        totalPlayersLabel.font = ._14MontserratRegular
        totalPlayersLabel.textColor = .primaryBlack
        totalPlayersLabel.text = "Total Players"
        contentView.addSubview(totalPlayersLabel)
        
        playersNeededTextField.font = ._14MontserratMedium
        playersNeededTextField.textColor = .primaryBlack
        playersNeededTextField.placeholder = "2"
        playersNeededTextField.delegate = self
        playersNeededTextField.returnKeyType = .done
        playersNeededTextField.keyboardType = .numberPad
        playersNeededTextField.layer.borderColor = UIColor.gray01.cgColor
        playersNeededTextField.layer.borderWidth = 1
        playersNeededTextField.layer.cornerRadius = 5
        playersNeededTextField.layer.masksToBounds = true
        playersNeededTextField.textAlignment = .center
        contentView.addSubview(playersNeededTextField)
        
        playersNeededLabel.font = ._14MontserratRegular
        playersNeededLabel.textColor = .primaryBlack
        playersNeededLabel.text = "Players Needed"
        contentView.addSubview(playersNeededLabel)
        
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        let contentInteritemHorizontalPadding = 12
        let contentInteritemVerticalPadding = 14
        let contentHorizontalPadding = 24
        let contentVerticalPadding = 18
        
        let textFieldHeight = 28
        let textFieldWidth = 32
        
        let dividerHeight = 1
        let horizontalPadding = 16
        let topPadding = 24
        
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().offset(topPadding)
        }
        
        totalPlayersTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(contentHorizontalPadding)
            make.top.equalTo(headerLabel.snp.bottom).offset(contentVerticalPadding)
            make.height.equalTo(textFieldHeight)
            make.width.equalTo(textFieldWidth)
        }
        
        totalPlayersLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPlayersTextField.snp.centerY)
            make.leading.equalTo(totalPlayersTextField.snp.trailing).offset(contentInteritemHorizontalPadding)
            make.trailing.equalToSuperview().offset(contentHorizontalPadding)
        }
        
        playersNeededTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(contentHorizontalPadding)
            make.top.equalTo(totalPlayersTextField.snp.bottom).offset(contentInteritemVerticalPadding)
            make.height.equalTo(textFieldHeight)
            make.width.equalTo(textFieldWidth)
        }
        
        playersNeededLabel.snp.makeConstraints { make in
            make.centerY.equalTo(playersNeededTextField.snp.centerY)
            make.leading.equalTo(playersNeededTextField.snp.trailing).offset(contentInteritemHorizontalPadding)
            make.trailing.equalToSuperview().offset(contentHorizontalPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(dividerHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SportsFormPlayersCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
