//
//  OpenAIKit.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public final class OpenAIKit: NSObject {
	private let apiToken: String
	private let organization: String?
	
	internal var network = OpenAIKitNetwork(session: URLSession(configuration: URLSessionConfiguration.default))
	
	internal let jsonEncoder = JSONEncoder.aiEncoder
	
	public let customOpenAIURL: String?
	
	private let sslCerificatePath: String?
	
	private(set) weak var sslDelegate: OpenAISSLDelegate?
	
	/// Initialize `OpenAIKit` with your API Token wherever convenient in your project. Organization name is optional.
	public init(apiToken: String, organization: String? = nil, timeoutInterval: TimeInterval = 60, customOpenAIURL: String? = nil, sslCerificatePath: String? = nil) {
		self.apiToken = apiToken
		self.organization = organization
		self.customOpenAIURL = customOpenAIURL
		self.sslCerificatePath = sslCerificatePath
		
		let delegate = OpenAISSLDelegate(sslCerificatePath: sslCerificatePath)
		
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = timeoutInterval
		configuration.timeoutIntervalForResource = timeoutInterval
		configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
		
		let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
		
		self.network = OpenAIKitNetwork(session: session, sslDelegate: delegate)
		self.sslDelegate = delegate
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
