//
//  SearchResultModel.swift
//  GithubGraphQL
//
//  Created by Annemarie Ketola on 3/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

struct SearchResultModel {
    var name: String
    var path : String
    var owner : String
    var avatar : String?
    var stars: Int = 0
} 

struct testStruct {
    var stuff : String
}
