//
//  GymDetail.swift
//  Uplift
//
//  Created by Kevin Chan on 9/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

struct GymDetail {

    let gym: Gym
    var hoursDataIsDropped: Bool
    let facilities: [String]
    
    private let facilitiesData: [String: [String]] = [
        GymIds.appel: ["Fitness Center"],
        GymIds.helenNewman: ["Fitness Center", "Pool", "16 Lane Bowling Center", "Two-Court Gymnasium", "Dance Studio"],
        GymIds.noyes: ["Fitness Center", "Game Area", "Indoor Basketball Court", "Outdoor Basketball Court", "Bouldering Wall", "Multi-Purpose Room"],
        GymIds.teagleDown: ["Fitness Center", "Pool"],
        GymIds.teagleUp: ["Fitness Center", "Pool"]
    ]

    init(gym: Gym) {
        self.gym = gym
        self.hoursDataIsDropped = false
        self.facilities = facilitiesData[gym.id] ?? []
    }

}
