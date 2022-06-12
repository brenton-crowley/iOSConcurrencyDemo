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
    
    @MainActor
    func fetchUsers() async {
        
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        self.isLoading = true
        
        defer { isLoading = false }
        
        // simulate slow load.
        //        DispatchQueue.main.asyncAfter(deadline: .now() + GlobalConstants.simulatedLoadingDelay) {
        // will run AFTER the code from outside this scope but inside this function finishes
        // In other words, after we receive a result.
        
        do {
            users = try await apiService.getJSON()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }

    }
}

extension UsersListViewModel {
    
    convenience init(forPreview:Bool = false) {
        self.init()
        
        if forPreview { self.users = User.mockUsers }
    }
}
