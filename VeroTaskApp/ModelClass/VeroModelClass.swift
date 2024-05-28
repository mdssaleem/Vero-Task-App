//
//  VeroModelClass.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import Foundation
import SwiftyJSON




class VeroModelClass {
    
       var task: String?
       var title: String?
       var description: String?
       var sort: String?
       var wageType: String?
       var businessUnitKey: String?
       var businessUnit: String?
       var parentTaskID: String?
       var preplanningBoardQuickSelect: String?
       var colorCode: String?
       var workingTime: String?
       var isAvailableInTimeTrackingKioskMode: Bool?

    init(json: JSON) {
        self.task = json["task"].stringValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.sort = json["sort"].stringValue
        self.wageType = json["wageType"].stringValue
        self.businessUnitKey = json["BusinessUnitKey"].stringValue
        self.businessUnit = json["businessUnit"].stringValue
        self.parentTaskID = json["parentTaskID"].stringValue
        self.preplanningBoardQuickSelect = json["preplanningBoardQuickSelect"].string
        self.colorCode = json["colorCode"].stringValue
        self.workingTime = json["workingTime"].string
        self.isAvailableInTimeTrackingKioskMode = json["isAvailableInTimeTrackingKioskMode"].boolValue
    }
    
    init() {
        self.title = ""
        self.description = ""
        self.sort = ""
        self.wageType = ""
        self.businessUnitKey = ""
        self.businessUnit = ""
        self.parentTaskID = ""
        self.preplanningBoardQuickSelect = ""
        self.colorCode = ""
        self.workingTime = ""
        self.isAvailableInTimeTrackingKioskMode = false
    }
}
