//
//  PageResponse.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/27/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class PageResponse<T: Codable>: Codable {
    let pagination: Pagination?
    let pageResult: [T]
    
    init(pagination: Pagination, pageResult: [T]) {
        self.pagination = pagination
        self.pageResult = pageResult
    }
}

class Pagination: Codable {
    let currentPage, pageSize, totalPage, totalItemCount: Int
    
    init(currentPage: Int, pageSize: Int, totalPage: Int, totalItemCount: Int) {
        self.currentPage = currentPage
        self.pageSize = pageSize
        self.totalPage = totalPage
        self.totalItemCount = totalItemCount
    }
}
