//
//  ConfigModel.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/23.
//  Copyright © 2017 He Wu. All rights reserved.
//

import Foundation
import ObjectMapper

final class ConfigModel: Mappable{
    private struct Constants {
        static let apiUrl = "api_url"
    }
    
    var apiUrl: String?
    
    required init?(map: Map) {}
    
    //Mappable
    func mapping(map: Map) {
        apiUrl <- map[Constants.apiUrl]
    }
}


