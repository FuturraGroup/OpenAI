//
//  OpenAIKitNetwork.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAINetworkError: Error {
	case invalidURL
	case invalidResponse
}

public final class OpenAIKitNetwork {
	private let session: URLSession
	
	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
	
	func request<ResponseType: Decodable>(_ method: OpenAIHTTPMethod, url: String, body: Data? = nil, headers: OpenAIHeaders? = nil, completion: @escaping (Result<ResponseType, Error>) -> Void) {
		guard let url = URL(string: url) else {
			completion(.failure(OpenAINetworkError.invalidURL))
			return
		}
			
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = body
		
		headers?.forEach { key, value in
			request.addValue(value, forHTTPHeaderField: key)
		}
			
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
				
			guard let data = data, let response = response as? HTTPURLResponse else {
				completion(.failure(OpenAINetworkError.invalidResponse))
				return
			}
				
			guard 200 ... 299 ~= response.statusCode else {
				var userInfo: [String: Any] = [:]
				
				if let decodedError = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
					userInfo = decodedError
				}
				
				let error = NSError(domain: NSURLErrorDomain, code: response.statusCode, userInfo: userInfo)
				completion(.failure(error))
				return
			}
				
			do {
				let decoder = JSONDecoder.aiDecoder
				let responseObj = try decoder.decode(ResponseType.self, from: data)
				completion(.success(responseObj))
			} catch {
				completion(.failure(error))
			}
		}
			
		task.resume()
	}
}
