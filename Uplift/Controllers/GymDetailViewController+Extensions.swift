//
//  GymDetailViewController+Extensions.swift
//  Fitness
//
//  Created by Yana Sang on 5/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

extension GymDetailViewControllerNew: GymDetailHoursCellDelegate {
    func didDropHours(isDropped: Bool, completion: @escaping () -> Void) {
        hoursIsDropped.toggle()
        collectionView.performBatchUpdates({}, completion: nil)
        completion()
    }
}

extension GymDetailViewControllerNew: GymDetailTodaysClassesCellDelegate {

    func didSelectClassSession(_ session: GymClassInstance) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: session)
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }

}
