//
//  Comment.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

struct Comment{
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
    
    init(byPostId postId: Int?, byId id:Int?, byName name: String?, byEmail email:String?, byBody body:String?){
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
        
    }
}
