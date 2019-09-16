//
//  NetworkProcessor.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

//create url request and serialize json data to foundation objects
class NetworkProcessor {
    private lazy var configuration = URLSessionConfiguration.default
    private lazy var session: URLSession = URLSession(configuration: configuration)
    
    private let url: URL

    init(url: URL){
        self.url = url
    }
    
    //first value is dictionary that represent json data, second dictionary holds all headers from http response
    typealias JSONDictionaryHandler = (([String:Any]?,[AnyHashable:Any]?) -> Void)
    
    func downloadJSONFromUrl(completion: @escaping JSONDictionaryHandler){
        let request = URLRequest(url:self.url)
        let dataTask = self.session.dataTask(with: request) { (data, response, error) in
            if nil == error {
                if let httpResponse = response as? HTTPURLResponse {
                    switch(httpResponse.statusCode){
                        //successful response
                        case 200:
                            if let data = data{
                                do {
                                    let jsonDictionry = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                    completion(jsonDictionry as? [String:Any], httpResponse.allHeaderFields)
                                    
                                }catch let error as NSError{
                                    print("Error processing json data: \(error.localizedDescription)")
                                }
                            }
                            break;
                        
                        default:
                            print("HTML Response code: \(httpResponse.statusCode)")
                            break;
                    }
                }
            }else{
                print("Error: \(error!.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
