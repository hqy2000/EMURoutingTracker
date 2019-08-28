//
//  TrainList.swift
//  ios
//
//  Created by hqy2000 on 7/8/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

public final class TrainList: ImmutableMappable, Codable {
    required public init(map: Map) throws {
        self.regex = try map.value("regex")
        self.list = try map.value("list")
    }
    
    private struct Regex: ImmutableMappable, Codable {
        init(map: Map) throws {
            self.name = try map.value("name")
            self.match = try map.value("match")
        }
        
        let name: String
        let match: String
    }
    
    private class List: ImmutableMappable, Codable {
        required init(map: Map) throws {
            self.name = try map.value("name")
            self.list = try map.value("list")
        }
        
        let name: String
        let list: [String]
    }
    
    private let regex: [Regex]
    private let list: [List]
    
    public func getModel(_ train: String) -> String? {
        for model in self.list {
            if model.list.contains(train) {
                return model.name
            }
        }
        
        for regex in self.regex {
            do {
                let expression = try NSRegularExpression(pattern: regex.match)
                let results = expression.matches(in: train, range: NSRange(train.startIndex..., in: train))
                if results.count > 0 {
                    return regex.name
                }
            } catch {
                
            }
            
        }
        
        return nil
    }
}
