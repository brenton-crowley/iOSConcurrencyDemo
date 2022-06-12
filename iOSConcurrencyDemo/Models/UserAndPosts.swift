//
//  UserAndPosts.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 12/6/2022.
//

import Foundation

struct UserAndPosts: Identifiable {
    
    var id = UUID()
    
    let user: User
    let posts: [Post]
    
    var numberOfPosts: Int { posts.count }
    
}
