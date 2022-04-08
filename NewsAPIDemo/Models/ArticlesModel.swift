//
//  ArticlesModel.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/4/2.
//

import Foundation

struct ArticlesModel: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let author: String?
    let content: String?
    let description: String?
    let publishedAt: String?
//    let source: Source
    let title: String?
    let url: String?
    let urlToImage: String?
    
}


