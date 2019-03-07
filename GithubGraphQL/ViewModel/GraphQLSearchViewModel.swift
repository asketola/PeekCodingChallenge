//
//  GraphQLSearchViewModel.swift
//  GithubGraphQL
//
//  Created by Annemarie Ketola on 3/4/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol GraphQLSearchViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class GraphQLSearchViewModel {
    private weak var delegate: GraphQLSearchViewModelDelegate?
    
    private var searchGQLDataResults: [SearchResultModel] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false

    var firstQuery = true
    var lastQueryString = ""
    var hasNextPage = true
    var endCursor = ""
    
    init(delegate: GraphQLSearchViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return searchGQLDataResults.count - 1
    }
    
    func searchGQLDataResult(at index: Int) -> SearchResultModel {
        return searchGQLDataResults[index]
    }


    func fetchGraphQLData() {
        // Check to make sure a request isn't already going on
        guard !isFetchInProgress else {
            return
        }
        print("endCursor \(self.endCursor)")
        
        // set this to true
        isFetchInProgress = true
        
        // create new data array for the new search
        var newSearchGQLData: [SearchResultModel] = []
        
        var gqlQuery : SearchRepositoriesQuery?
        //Initial query
        //Feel free to update the number of item requested according to your implementation
        if firstQuery {
            gqlQuery = SearchRepositoriesQuery.init(first: 13, query: "graphql", type: SearchType.repository)
        } else {
            //Paginated search Query
            //gqlQuery = SearchRepositoriesQuery.init(first: 5, after: "Y3Vyc29yOjQ=", query: "graphql", type: SearchType.repository)
            gqlQuery = SearchRepositoriesQuery.init(first: 13, after: endCursor, query: "graphql", type: SearchType.repository)
        }
        
        RepositoriesGraphQLClient.searchRepositories(query: gqlQuery!) { (result) in
            switch result {
            case .success(let data):
                if let gqlResult = data {
                    
                    if let pageInfo = gqlResult.data?.search.pageInfo {
                        /*print("pageInfo: \n")
                        print("hasNextPage: \(pageInfo.hasNextPage)")
                        print("hasPreviousPage: \(pageInfo.hasPreviousPage)")
                        print("startCursor: \(String(describing: pageInfo.startCursor))")
                        print("endCursor: \(String(describing: pageInfo.endCursor))")
                        print("\n")*/
                        
                        self.hasNextPage = pageInfo.hasNextPage
                        self.endCursor = pageInfo.endCursor!
                    }
                    
                    
                    gqlResult.data?.search.edges?.forEach { edge in
                        guard let repository = edge?.node?.asRepository?.fragments.repositoryDetails else { return }
                        /*print("Name: \(repository.name)")
                        print("Path: \(repository.url)")
                        print("Owner: \(repository.owner.login)")
                        print("avatar: \(repository.owner.avatarUrl)")
                        print("Stars: \(repository.stargazers.totalCount)")
                        print("\n")*/
                        
                        let searchModel = SearchResultModel(name: repository.name, path: repository.url, owner: repository.owner.login, avatar: repository.owner.avatarUrl, stars: repository.stargazers.totalCount)
                        
                        newSearchGQLData.append(searchModel)
                        print(searchModel)
                    }
                    DispatchQueue.main.async {
                        self.currentPage += 1
                        self.isFetchInProgress = false
                        
                        self.total += self.total + newSearchGQLData.count // testing here
                        self.searchGQLDataResults.append(contentsOf: newSearchGQLData)
                        
                        if !self.firstQuery {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from: newSearchGQLData)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                            self.firstQuery = false
                        }
                    }
                }
            case .failure(let error):
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        self.isFetchInProgress = false
                        self.delegate?.onFetchFailed(with: error.localizedDescription )
                        print("Error code \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func calculateIndexPathsToReload(from newData: [SearchResultModel]) -> [IndexPath] {
        let startIndex = searchGQLDataResults.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}
