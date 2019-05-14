//
//  Gym.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct Gym {
    let id: String
    let equipment: String
    let gymHours: [DailyGymHours]
    let name: String

    /// Array of 7 arrays of count 24, representing the busyness in each hour, Sun..Sat
    let popularTimesList: [[Int]]
    let imageURL: URL?
    var isOpen: Bool {
        return Date() > gymHoursToday.openTime ? Date() < gymHoursToday.closeTime : false
    }
    
    var closedTomorrow: Bool {
        let now = Date()
        let gymHoursTomorrow = gymHours[now.getIntegerDayOfWeekTomorrow()]
        return gymHoursTomorrow.openTime == gymHoursTomorrow.closeTime
    }

    var gymHoursToday: DailyGymHours {
        return gymHours[Date().getIntegerDayOfWeekToday()]
    }

    init(gymData: AllGymsQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name

        equipment = "" // TODO : fetch equipment once it's availble from backend
        imageURL = URL(string: gymData.imageUrl ?? "")

        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)

        if let popular = gymData.popular {
            for i in 0..<popular.count {
                if let dailyPopular = popular[i] {
                    for j in 0..<dailyPopular.count {
                        popularTimes[i][j] = dailyPopular[j] ?? 0
                    }
                }
            }
        }
        popularTimesList = popularTimes

        // unwrap gym hours
        var gymHoursList: [DailyGymHours] = []

        let allGymHours = gymData.times
        for i in 0..<allGymHours.count {
            gymHoursList.append(DailyGymHours(gymHoursData: allGymHours[i]))
        }

        gymHours = gymHoursList
    }
    
    init(gymData: GymByIdQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name
        
        equipment = "" // TODO : fetch equipment once it's availble from backend
        imageURL = URL(string: gymData.imageUrl ?? "")
        
        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)
        
        if let popular = gymData.popular {
            for i in 0..<popular.count {
                if let dailyPopular = popular[i] {
                    for j in 0..<dailyPopular.count {
                        popularTimes[i][j] = dailyPopular[j] ?? 0
                    }
                }
            }
        }
        popularTimesList = popularTimes
        
        // unwrap gym hours
        var gymHoursList: [DailyGymHours] = []
        
        let allGymHours = gymData.times
        for i in 0..<allGymHours.count {
            gymHoursList.append(DailyGymHours(gymHoursDataId: allGymHours[i]))
        }
        
        gymHours = gymHoursList
    }
}

struct DailyGymHours {
    var dayOfWeek: Int
    var openTime: Date
    var closeTime: Date

    init(gymHoursData: AllGymsQuery.Data.Gym.Time?) {

        if let gymHoursData = gymHoursData {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }
    
    init(gymHoursDataId: GymByIdQuery.Data.Gym.Time?) {
        
        if let gymHoursData = gymHoursDataId {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }
}
