//
//  ConfigService.swift
//  MusicLover
//
//  Created by ST21235 on 2017/10/23.
//  Copyright © 2017 He Wu. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConfigEnv {
    static let Debug = "https://jsonplaceholder.typicode.com/"
    static let Release = "https://jsonplaceholder.typicode.com/"
    static let Tests = "https://jsonplaceholder.typicode.com/"
}

protocol ConfigServiceProtocol: class{
    var apiUrl: String? { get }
}

//final class ConfigService: ConfigServiceProtocol{
//    private let configEnv: ConfigEnv
//    private lazy var configModel: ConfigModel? = {
//        guard let json = ConfigHelper.json(for: self.configEnv),
//            let model = Mapper<ConfigModel>().map(JSONString: json) else {
//                return nil
//        }
//        
//        return model
//    }()
//    
//    var apiUrl: String? {
//        return configModel?.apiUrl
//    }
//    
//    init(configEnv: ConfigEnv) {
//        self.configEnv = configEnv
//    }
//    
//}

