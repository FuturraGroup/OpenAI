//
//  OpenAIKit.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public final class OpenAIKit {
	private let apiToken: String
	private let organization: String?
	
	internal let network: OpenAIKitNetwork
	
	internal let jsonEncoder = JSONEncoder.aiEncoder
	
	/// Initialize `OpenAIKit` with your API Token wherever convenient in your project. Organization name is optional.
	public init(apiToken: String, organization: String? = nil, timeoutInterval: TimeInterval = 60) {
		self.apiToken = apiToken
		self.organization = organization
		
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = timeoutInterval
		configuration.timeoutIntervalForResource = timeoutInterval

		let session = URLSession(configuration: configuration)
		
		network = OpenAIKitNetwork(session: session)
	}
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension OpenAIKit {
	var baseHeaders: OpenAIHeaders {
		var headers: OpenAIHeaders = [:]
		
		headers["Authorization"] = "Bearer \(apiToken)"
		
		if let organization {
			headers["OpenAI-Organization"] = organization
		}
		
		headers["content-type"] = "application/json"
		
		return headers
	}
    
    var baseMultipartHeaders: OpenAIHeaders {
        var headers: OpenAIHeaders = [:]
        
        headers["Authorization"] = "Bearer \(apiToken)"
        
        if let organization {
            headers["OpenAI-Organization"] = organization
        }
        
        headers["content-type"] = "multipart/form-data"
        
        return headers
    }
}
