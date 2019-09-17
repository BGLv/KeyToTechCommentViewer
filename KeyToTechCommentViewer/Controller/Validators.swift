//
//  Validators.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String){
        self.message = message
    }
}

protocol ValidationConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType{
    case commentIdBound
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidationConvertible {
        switch type {
            case .commentIdBound: return CommentIdBoundValidator()
        }
    }
}


struct CommentIdBoundValidator: ValidationConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Bound is required")}
        guard let bound = Int(value) else {throw ValidationError("Bound must be a number!")}
        guard bound > 0 else {throw ValidationError("Bound must be greater than 0!")}
        
        return value
    }
}
