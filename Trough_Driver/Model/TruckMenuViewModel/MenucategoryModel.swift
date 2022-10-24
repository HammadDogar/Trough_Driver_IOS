//
//  MenucategoryModel.swift
//  Trough_Driver
//
//  Created by Macbook on 07/04/2021.
//

struct MenuCategoryModel {
    var title : String?
    var description : String?
    
    
    init(){
        self.title = ""
        self.description = ""
        
    }
    init(tit:String,des:String) {
        self.title = tit
        self.description = des
    }
}
