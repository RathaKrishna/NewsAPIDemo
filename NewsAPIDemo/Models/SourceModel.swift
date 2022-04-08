//
//  SourceModel.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 08/04/22.
//

import Foundation


struct SourceModel: Codable {
    let sources: [Source]
}

struct Source: Codable {
    let id: String
    let name: String
    let url: String?
//    let language: String?
//    let country: String?
      
}

