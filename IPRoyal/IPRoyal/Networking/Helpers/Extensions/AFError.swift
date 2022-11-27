//
//  AFError.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-27.
//

import Alamofire

extension AFError {
    var asResponseError: ResponseError {
        ResponseError(localizedDescription: localizedDescription)
    }
}
