//
//  VeroModelClassOffline.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 29/05/24.
//

import Foundation

class VeroModelClassOffline
{
    
    var task: String = ""
    var title: String = ""
    var description: String = ""
    var colorCode: String = ""
   
   
    var nameString: String = ""
    var imgUrlString: String = ""
    var descriptionString: String = ""
    var idString: Int = 0
    var taskString: String = ""


    
    init(name:String,image:String,description:String,id:Int,task:String)
    {
        self.nameString = name
        self.imgUrlString = image
        self.descriptionString = description
        self.idString = id
        self.taskString = task
    }
        
    init(task:String,title:String,description:String,colorCode:String)
    {
        self.task = task
        self.title = title
        self.description = description
        self.colorCode = colorCode

    }
    
}
