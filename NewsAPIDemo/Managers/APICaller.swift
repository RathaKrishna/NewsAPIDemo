//
//  APICaller.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/4/2.
//

import Foundation
import Alamofire

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    
    struct Constants {
        static let baseUrl = "https://newsapi.org/v2/"
        static let breakingNewsUrl = baseUrl + "top-headlines?country=IN"
        static let newsUrl = baseUrl + "everything?q=all"
        static let searchUrl = baseUrl + "everything?sortBy=popularity"
        static let sourcesUrl = ""
        
    }
    
    struct responseData {
        var request: URLRequest?
        var response: HTTPURLResponse?
        var error: NSError?
        var data: Data?
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: Get breaking News
    public func getBreakingNews(completion: @escaping (Result<[Articles], Error>) -> Void) {
        
        creatRequestWith(Method: .get, URL: Constants.breakingNewsUrl, Parameter: nil) { response in
            
            guard let data = response.data , response.error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                
                let result = try JSONDecoder().decode(ArticlesModel.self
                                                      , from: data)
                completion(.success(result.articles))
            }
            catch {
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - Get everything
    public func getAllNews(completion: @escaping (Result<[Articles], Error>) -> Void) {
        creatRequestWith(Method: .get, URL: Constants.newsUrl, Parameter: nil) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
//                let json:AnyObject! = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as AnyObject
//                print(json)
                let result = try JSONDecoder().decode(ArticlesModel.self, from: data)
                completion(.success(result.articles))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Search News
    public func searchNews(with query: String, completion: @escaping (Result<[Articles], Error>) -> Void) {
        
        creatRequestWith(Method: .get, URL: Constants.searchUrl + "&q=\(query)&from=\(DateFormatter.df.string(from: Date().threeDayBefore))", Parameter: nil) { response in
            
            guard let data = response.data , response.error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                
                let result = try JSONDecoder().decode(ArticlesModel.self
                                                      , from: data)
                print(result.articles)
                completion(.success(result.articles))
            }
            catch {
                completion(.failure(error))
            }
        }
        
    }
    
    // Authorization with Key
    private let headers: HTTPHeaders = [
        "Authorization": "5b4d396ea31b4a6c945f3c35218a86e2",
        "Accept": "application/json"
    ]
    
    // MARK: - Create request with Headers
    private func creatRequestWith(Method method: Alamofire.HTTPMethod, URL url: String, Parameter param: [String: Any]?, completion: @escaping (responseData) -> Void) {
        
        AF.request(url, method: method, parameters: param, headers: headers, requestModifier: { request in
            request.timeoutInterval = 6
        }).response { response in
            let result = responseData(request: response.request, response: response.response, error: response.error as NSError?, data: response.data)
            completion(result)
        }
    }
    
    
}



//                 let json:AnyObject! = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as AnyObject
