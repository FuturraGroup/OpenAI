//
//  OpenAIKit.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

public final class OpenAIKit {
	private let apiToken: String
	private let organization: String?
	
	internal let network: OpenAIKitNetwork
	
	internal let jsonEncoder = JSONEncoder.aiEncoder
	
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
}
