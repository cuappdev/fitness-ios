//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation
import Alamofire
import Apollo
import Foundation
import Kingfisher

enum APIEnvironment {
    case development
    case production
}

struct NetworkManager {
    internal let apollo = ApolloClient(url: URL(string: "http://uplift-backend.cornellappdev.com")!)
    static let environment: APIEnvironment = .development
    static let shared = NetworkManager()

    
    // MARK: - Google
    func sendGoogleLoginToken(token: String, completion: @escaping () -> Void) {
        let tokenURL = "http://uplift-backend.cornellappdev.com/login/"
        let parameters: [String: Any] = [
            "token": token
        ]
        
        Alamofire.request(tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseData{ (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let tokenResults = try? decoder.decode(GoogleTokens.self, from: data) {
                    UserGoogleTokens.backendToken = tokenResults.backendToken
                    UserGoogleTokens.expiration = tokenResults.expiration
                    UserGoogleTokens.refreshToken = tokenResults.refreshToken
                    
                    completion()
                }
                
            case .failure(let error):
                print("ERROR~~~:")
                print(error.localizedDescription)
            }
            
        }
    }
    
    func refreshGoogleToken(token: String, completion: @escaping () -> Void) {
        let tokenURL = "http://uplift-backend.cornellappdev.com/session/"
        let parameters: [String: Any] = [
            "bearer_token": token
        ]
        
        Alamofire.request(tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseData{ (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let tokenResults = try? decoder.decode(GoogleTokens.self, from: data) {
                    UserGoogleTokens.backendToken = tokenResults.backendToken
                    UserGoogleTokens.expiration = tokenResults.expiration
                    UserGoogleTokens.refreshToken = tokenResults.refreshToken
                    
                    completion()
                }
                
            case .failure(let error):
                print("ERROR~~~:")
                print(error.localizedDescription)
            }
            
        }
    }
    
    // MARK: - GYMS
    func getGyms(completion: @escaping ([Gym]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            var gyms: [Gym] = []

            for gymData in result?.data?.gyms ?? [] {
                if let gymData = gymData {
                    let gym = Gym(gymData: gymData)
                    gyms.append(gym)
                    if let imageUrl = gym.imageURL {
                        self.cacheImage(imageUrl: imageUrl)
                    }
                }
            }
            completion(gyms)
        }
    }
    
    func getGym(id: String, completion: @escaping (Gym) -> Void) {
        apollo.fetch(query: GymByIdQuery(gymId: id)) { (result, error) in
            
            guard let gymsData = result?.data?.gyms else { return }
            guard let gymData = gymsData[0] else { return }
            
            let gym = Gym(gymData: gymData)

            if let imageUrl = gym.imageURL {
                self.cacheImage(imageUrl: imageUrl)
            }
            
            completion(gym)
        }
    }

    func getGymNames(completion: @escaping ([GymNameId]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            // implement
            var gyms: [GymNameId] = []

            for gym in result?.data?.gyms ?? [] {
                guard let gym = gym else {
                    continue
                }

                gyms.append(GymNameId(name: gym.name, id: gym.id))
            }

            completion(gyms)
        }
    }

    func getGymClassesForDate(date: String, completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: TodaysClassesQuery(date: date)) { result, error in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                self.cacheImage(imageUrl: imageUrl)
                let instructor = gymClassData.instructor
                guard let startTime = gymClassData.startTime else { continue }
                guard let endTime = gymClassData.endTime else { continue }
                let isCancelled = gymClassData.isCancelled
                guard let gymId = gymClassData.gymId else { continue }
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let classId = gymClassData.details.id
                let className = gymClassData.details.name
                let date = gymClassData.date
                let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
                let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)
                let graphTags = gymClassData.details.tags.compactMap { $0 }
                let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: tags)

                gymClassInstances.append(gymClass)
            }
            completion(gymClassInstances)
        }
    }

    // MARK: - GYM CLASS INSTANCES
    func getGymClassInstancesByClass(gymClassDetailIds: [String], completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: ClassesByTypeQuery(classNames: gymClassDetailIds)) { (result, error) in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                let instructor = gymClassData.instructor
                guard let startTime = gymClassData.startTime else { continue }
                guard let endTime = gymClassData.endTime else { continue }
                let date = gymClassData.date
                let isCancelled = gymClassData.isCancelled
                guard let gymId = gymClassData.gymId else { continue }
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let classDetailId = gymClassData.details.id
                let className = gymClassData.details.name
                let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
                let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)
                
                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: [])
                
                gymClassInstances.append(gymClass)
            }
            let now = Date()
            gymClassInstances = gymClassInstances.filter {$0.startTime > now}
            gymClassInstances.sort {$0.startTime < $1.startTime}
            
            completion(gymClassInstances)
        }
    }
    
    func getClassInstancesByGym(gymId: String, date: String, completion: @escaping([GymClassInstance]) -> Void) {
        apollo.fetch(query: TodaysClassesAtGymQuery(gymId: gymId, date: date)) { (result, error) in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                let instructor = gymClassData.instructor
                guard let startTime = gymClassData.startTime else { continue }
                guard let endTime = gymClassData.endTime else { continue }
                let date = gymClassData.date
                let isCancelled = gymClassData.isCancelled
                guard let gymId = gymClassData.gymId else { continue }
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let classDetailId = gymClassData.details.id
                let className = gymClassData.details.name
                let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
                let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)
                
                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: [])
                
                gymClassInstances.append(gymClass)
            }
            let now = Date()
            gymClassInstances = gymClassInstances.filter {$0.startTime > now}
            gymClassInstances.sort {$0.startTime < $1.startTime}
            
            completion(gymClassInstances)
        }
    }

    // MARK: - TAGS
    func getTags(completion: @escaping ([Tag]) -> Void) {
        apollo.fetch(query: GetTagsQuery()) { (results, error) in
            guard let data = results?.data, let classes = data.classes else { return }
            let allClasses = classes.compactMap { $0 }

            var allTags: [Tag] = []
            for currClass in allClasses {
                let currTags = currClass.details.tags.compactMap { $0 }

                currTags.forEach { tag in
                    let currTag = Tag(name: tag.label, imageURL: tag.imageUrl)
                    if !allTags.contains(currTag) {
                        allTags.append(currTag)
                    }
                    if let imageURL = URL(string: currTag.imageURL) {
                        self.cacheImage(imageUrl: imageURL)
                    }
                }
            }
            completion(allTags)
        }

    }

    // MARK: - GYM CLASSES
    func getClassNames(completion: @escaping (Set<String>) -> Void) {
        apollo.fetch(query: AllClassNamesQuery()) { (result, error) in
            var classNames: Set<String> = []
            guard let gymClasses = result?.data?.classes else { return }

            let allGymClasses = gymClasses.compactMap { $0 }

            for gymClass in allGymClasses {
                classNames.insert(gymClass.details.name)
            }

            completion(classNames)
        }
    }
    
    // MARK: - INSTRUCTORS
    func getInstructors(completion: @escaping ([String]) -> Void) {
        apollo.fetch(query: GetInstructorsQuery()) { result, error in
            guard let data = result?.data else { return }

            var instructors: Set<String> = Set() // so as to return DISTINCT instructors
            for gymClass in data.classes ?? [] {
                if let instructor = gymClass?.instructor {
                    instructors.insert(instructor)
                }
            }
            completion(Array(instructors))
        }
    }

    // MARK: - Image Caching
    private func cacheImage(imageUrl: URL) {
        //Kingfisher will download the image and store it in the cache
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
