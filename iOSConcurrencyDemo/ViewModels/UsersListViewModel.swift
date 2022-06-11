//
//  UsersListViewModel.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage:String?
    
    func fetchUsers() {
        
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        self.isLoading = true
        
        // simulate slow load.
        //        DispatchQueue.main.asyncAfter(deadline: .now() + GlobalConstants.simulatedLoadingDelay) {
        // will run AFTER the code from outside this scope but inside this function finishes
        // In other words, after we receive a result.
        defer {
            DispatchQueue.main.async { self.isLoading = false }
        }
        
        apiService.getJSON { (result: Result<[User], APIError>) in
            switch result {
            case .success(let users):
                DispatchQueue.main.async { self.users = users }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                }
            }
        }
        //        }
    }
}

extension UsersListViewModel {
    
    convenience init(forPreview:Bool = false) {
        self.init()
        
        if forPreview { self.users = User.mockUsers }
    }
}
