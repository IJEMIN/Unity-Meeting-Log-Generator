//
//  OpenAITypes.swift
//  Unity Meeting Log Generator
//
//  Created by Unity Jemin on 2023/09/18.
//

import Foundation


public class OpenAIManager : Codable {
    public var messages : [RequestMessage] = []
}

public struct OpenApi
{
  public static let Url = "https://api.openai.com/v1/chat/completions";
}


public struct ResponseMessage : Codable
{
    public var role : String
    public var content : String
}


public struct ResponseChoice : Codable
{
    public var index: Int
    public var message: ResponseMessage
}


public struct OpenResponse : Codable
{
    public var id: String
    public var choices: [ResponseChoice]
}


public struct RequestMessage : Codable
{
    public var role: String
    public var content: String
}


public struct Request : Codable
{
    public var model: String
    public var messages: [RequestMessage]
}
