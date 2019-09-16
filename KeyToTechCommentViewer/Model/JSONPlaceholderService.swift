//
//  JSONPlaceholderService.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

//PUBLIC INTERFACE OF JSONPlaceholderService
extension JSONPlaceholderService{
    
    func getCommentsStarted(with start:Int?, limitedBy: Int?, completion: @escaping ([Comment]?,Int?)->Void){
        //init network processor with url to comments
        let networkProcessor = NetworkProcessor(url: makeGetCommentsURLComponent(start: start, limit: limitedBy).url!)
        
        //get comments in form array of dictionarys, and get HTTPHeader dictionary to found total comments X-Total-Count
        networkProcessor.downloadJSONFromUrl { (jsonArrayOfDictionary, HTTPHeadersDictionary) in
            //array of comments
            var comments:[Comment] = []
            //number of all avaliable comments
            let totalComments = HTTPHeadersDictionary?["X-Content-Count"] as? Int
                if let arrayOfCommentDict = jsonArrayOfDictionary{
                    for commentDict in arrayOfCommentDict{
                        if let postId = commentDict["postId"] as? Int,
                            let id = commentDict["id"] as? Int,
                            let name = commentDict["name"] as? String,
                            let email = commentDict["email"] as? String,
                            let body = commentDict["body"] as? String{
                            comments.append(Comment(byPostId: postId, byId: id, byName: name, byEmail: email, byBody: body))
                        }
                    }
                }
                //call calback function with comments and number of total comments
                completion(comments,totalComments)
        }
    }
    
}


class JSONPlaceholderService {
    struct JSONPlaceholderAPI {
        static let scheme = "https"
        static let host = "jsonplaceholder.typicode.com"
        static let pathToAllComments = "/comments"
    }
    
    //create url components to get all comments limited by limit
    private func makeGetCommentsURLComponent(start: Int?, limit: Int?) -> URLComponents{
        var components = URLComponents()
        components.scheme = JSONPlaceholderAPI.scheme
        components.host = JSONPlaceholderAPI.host
        components.path = JSONPlaceholderAPI.pathToAllComments
        
        if let start = start {
            components.queryItems?.append(URLQueryItem(name: "_start", value: "\(start)"))
        }
        if let limit = limit {
            components.queryItems?.append(URLQueryItem(name: "_limit", value: "\(limit)"))
        }
        return components
    }
    
}
