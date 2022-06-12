//
//  UsersListViewModel.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var userAndPosts: [UserAndPosts] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage:String?
    
    @MainActor
    func fetchUsers() async {
        
        let apiUsersService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiPostsService = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        
        self.isLoading = true
        
        defer { isLoading = false }
        
        // simulate slow load.
        //        DispatchQueue.main.asyncAfter(deadline: .now() + GlobalConstants.simulatedLoadingDelay) {
        // will run AFTER the code from outside this scope but inside this function finishes
        // In other words, after we receive a result.
        
        do {
            // prefic with async so that users and posts can be fetched independently of one another.
            async let users: [User] = try await apiUsersService.getJSON()
            async let posts: [Post] = try await apiPostsService.getJSON()
            
            // store the results in a tuple.
            // must prefix each result with try as they may not exist
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            
            fetchedUsers.forEach { user in
                let userPosts = fetchedPosts.filter { $0.userId == user.id }
                let newUserAndPosts = UserAndPosts(user: user, posts: userPosts)
                userAndPosts.append(newUserAndPosts)
            }
            
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }

    }
}

extension UsersListViewModel {
    
    convenience init(forPreview:Bool = false) {
        self.init()
        
        if forPreview { self.userAndPosts = UserAndPosts.mockUserAndPosts }
    }
}
