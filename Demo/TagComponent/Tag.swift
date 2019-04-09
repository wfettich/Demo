//
//  Tag.swift
//  TravelLive
//
//  Created by Catalin-Andrei BORA on 3/16/18.
//  Copyright © 2018 digitalPomelo. All rights reserved.
//

import Foundation

public struct Tag : Codable, Equatable
{
    
    public var name: String
    public var category:String = "customFilters"
    public var value: String
    public var selected: Bool
    public var optional: Bool
    public var orderNumber: Int? = nil
    public var extraInfo: Dictionary<String,String> = [:]
    
    init(name: String, value:String? = nil, category:String = "customFilters", selected: Bool = true, optional: Bool = true) {
        
        self.name = name
        self.value = value ?? name
        self.selected = selected
        self.optional = optional
        self.category = category
    }
    
    public enum CodingKeys: String, CodingKey {
        case name
        case category
        case value
        case selected
        case optional
        case orderNumber
        case extraInfo
    }
    
    
    func replaceInDictionary(dict:inout Dictionary<String,[String]>)
    {
        dict[category] = [value]
    }
    
    func addToDictionary(dict:inout Dictionary<String,[String]>)
    {
        dict.merge([category:[value]]) { (val1, val2) -> [String] in
            return val1 + val2
        }
        
        if let d = extraInfo["distance"] as? String
        {
            dict["distance"] = [d]
        }
    }
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.value.lowercased() == rhs.value.lowercased() && lhs.category.lowercased() == rhs.category.lowercased()
    }
    
    func isNearMeTag() -> Bool
    {
        return (//the old way, keep it here for old versions
            self.name == "Near Me"
                //the new way
                || self.extraInfo["isNearMe"] == "true"
        )
    }
}
