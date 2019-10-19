//
//  WeekDay.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/12/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

enum WeekDay: String, CaseIterable {
    case monday = "M"
    case tuesday = "T"
    case wednesday = "W"
    case thursday = "Th"
    case friday = "F"
    case saturday = "Sa"
    case sunday = "Su"

    /// Constructs enum from index
    init(index: Int) {
        self = WeekDay.allCases[index]
    }

    /// Maps each enum case to index corresponding to ones returned by
    /// Calendar.current.component(.weekDay, from: Date())
    var index: Int { get {
        switch self {
        case .sunday:       return 1
        case .monday:       return 2
        case .tuesday:      return 3
        case .wednesday:    return 4
        case .thursday:     return 5
        case .friday:       return 6
        case .saturday:     return 7
        }}
    }

    /// Constructs enum from Weekday String
    init(day: String) {
        let d = day.lowercased()
        switch d {
            case "sunday":      self = .sunday
            case "monday":      self = .monday
            case "tuesday":     self = .tuesday
            case "wednesday":   self = .wednesday
            case "thursday":    self = .thursday
            case "friday":      self = .friday    
            case "saturday":    self = .saturday
            case "sunday":      self  = .sunday 
            default:
                print("Invalid Day String was passed: \(day) doesn't correspond to valid day")
                self = .sunday
        }
    }
}