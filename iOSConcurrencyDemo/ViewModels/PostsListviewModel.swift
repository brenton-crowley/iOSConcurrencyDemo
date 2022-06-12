//
//  PostsListviewModel.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage:String?
    
    var userId: Int?
    
    @MainActor
    func fetchPosts() async {
        
        if let userId = userId {
            
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            
            isLoading = true
            
            defer { isLoading = false } // runs after everything else in function has finished running
            
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
            }
            
//            apiService.getJSON { (result: Result<[Post], APIError>) in
//
//                switch result {
//                case .success(let posts):
//                    DispatchQueue.main.async { self.posts = posts }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert = true
//                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
//                    }
//                }
//
//            }
            
        }
    }
}

extension PostsListViewModel {
    
    convenience init(forPreview:Bool = false) {
        self.init()
        
        if forPreview { self.posts = Post.mockSingleUsersPostsArray }
    }
}
