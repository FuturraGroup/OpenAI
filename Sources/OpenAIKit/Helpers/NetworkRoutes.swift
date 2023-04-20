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

protocol Endpoint {
	var route: String { get }
	var method: OpenAIHTTPMethod { get }
	var baseURL: String { get }
	var urlPath: String { get }
}

enum OpenAIEndpoint {
	case completions
	case chatCompletions
	case edits
	case dalleImage
    case dalleImageEdit
}

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

	var baseURL: String {
		switch self {
		default:
			return "https://api.openai.com"
		}
	}

	var urlPath: String {
		baseURL + route
	}
}
