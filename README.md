# The Peek iOS Coding Challenge


<img src="https://cdn.worldvectorlogo.com/logos/graphql.svg" width="200" height="200" /><img src="https://openclipart.org/download/50143/clipart-0114.svg" width="50" height="50" /><img src="https://d2z5w7rcu7bmie.cloudfront.net/assets/images/logo.png" width="200" height="200" />



## Goal

Build a small iPhone application that queries Github to get repositories that mention `GraphQL`.
The result are to be displayed in a list view with pagination support.
The project should **not** take more than half a day of coding time - remember it’s a demo and not a fully featured app!
Please list in your README file the things you would have added/done differently if you had more time.

## Services
The application will interface with the [Github V4 API](https://developer.github.com/v4)

- [Perform a search](https://developer.github.com/v4/query)
- [Search Result](https://developer.github.com/v4/object/searchresultitemconnection/)


## Requirements

Initial launch: fetch the initial set of repos that contain the string `graphql`

Infinite scrolling: Fetch the next set of repository.

Each table cell should contain:

- The name of the repo
- The owner login name
- The owner avatar
- The number of stars

## Setup
This project uses [CocoaPods](https://cocoapods.org/) and leverages the [Apollo iOS client](https://github.com/apollographql/apollo-ios) to fetch data from a GraphQL API. In order to pull data from Github API, please generate an access [token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

The `githubToken` varaible will need to be updated the `GraphQLClientProtocol.swift` file.

## Libraries
You are allowed to used third party libraries when appropriate.
Use your good judgement and please justify the use (when necessary) of any third party library.

## Specifications
Language: Swift 4.2
Development environment: Xcode 10 or later
Target: iOS 12 or later

## Submission
When finished, create a public Github repository with your solution.
Don’t hesitate to include any documentation or ramblings to help us better understand your submission and the coding choices you made.
 
 
Finally, there are plenty of details that are purposefully vague here, because we want to give you leeway to be creative and show us your way of doing things. 

## Question?
If you have any questions, do not hesitate at all to ask (tony@peek.com).
