//
//  NetworkRoutes.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

enum OpenAIHTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
	case head = "HEAD"
	case options = "OPTIONS"
	case connect = "CONNECT"
	case trace = "TRACE"
}

typealias OpenAIHeaders = [String: String]

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
protocol Endpoint {
	var route: String { get }
	var method: OpenAIHTTPMethod { get }
	func urlPath(for aiKit: OpenAIKit) -> String
}

enum OpenAIEndpoint {
	case completions
	case chatCompletions
	case edits
	case dalleImage
	case dalleImageEdit
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension OpenAIEndpoint: Endpoint {
	var route: String {
		switch self {
		case .completions:
			return "/v1/completions"
		case .chatCompletions:
			return "/v1/chat/completions"
		case .edits:
			return "/v1/edits"
		case .dalleImage:
			return "/v1/images/generations"
		case .dalleImageEdit:
			return "/v1/images/edits"
		}
	}

	var method: OpenAIHTTPMethod {
		switch self {
		default:
			return .post
		}
	}

	private var baseURL: String {
		switch self {
		default:
			return "https://api.openai.com"
		}
	}

	func urlPath(for aiKit: OpenAIKit) -> String {
		(aiKit.customOpenAIURL ?? baseURL) + route
	}
}
