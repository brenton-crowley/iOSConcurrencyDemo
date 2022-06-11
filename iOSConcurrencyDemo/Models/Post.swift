//
//  Post.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/posts
// Single user's posts: https://jsonplaceholder.typicode.com/users/1/posts
// JSON and Decodable protocol: https://www.youtube.com/playlist?list=PLBn01m5Vbs4DKrm1gwIr_a-0B7yvlTZP6

struct Post: Codable, Identifiable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}

