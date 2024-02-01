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
	case invalidRequest
}

// MARK: -

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public final class OpenAIKitNetwork {
	private let session: URLSession
	private weak var sslDelegate: OpenAISSLDelegate?
	private var activeStreams: [NSObject] = []

	init(session: URLSession = URLSession.shared, sslDelegate: OpenAISSLDelegate? = nil) {
		self.session = session
		self.sslDelegate = sslDelegate
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

		let task = session.dataTask(with: request) { data, response, error in
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

	fileprivate struct StreamTaskState {
		var isStreamFinished = false
		var isStreamForceStop = false
	}

	func requestStream<ResponseType: Decodable>(_ method: OpenAIHTTPMethod, url: String, body: Data? = nil, headers: OpenAIHeaders? = nil, completion: @escaping (Result<AIStreamResponse<ResponseType>, Error>) -> Void) {
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

		var streamState = StreamTaskState()

		let stream = AIEventStream<ResponseType>(request: request, sslDelegate: sslDelegate)
		activeStreams.append(stream)

		stream.onMessage { data, message in
			completion(.success(AIStreamResponse(stream: stream, message: message, data: data, isFinished: streamState.isStreamFinished, forceEnd: streamState.isStreamForceStop)))
		}

		stream.onComplete { [weak self] _, forceEnd, error in
			if let error {
				completion(.failure(error))
				self?.terminateStream(stream)
				return
			}

			streamState.isStreamFinished = true
			streamState.isStreamForceStop = forceEnd

			completion(.success(AIStreamResponse(stream: stream, message: nil, data: nil, isFinished: streamState.isStreamFinished, forceEnd: streamState.isStreamForceStop)))

			self?.terminateStream(stream)
		}

		stream.startStream()
	}

	func requestStream<ResponseType: Decodable>(_ method: OpenAIHTTPMethod, url: String, body: Data? = nil, headers: OpenAIHeaders? = nil) async throws -> AsyncThrowingStream<AIStreamResponse<ResponseType>, Error> {
		guard let url = URL(string: url) else {
			throw OpenAINetworkError.invalidURL
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = body

		headers?.forEach { key, value in
			request.addValue(value, forHTTPHeaderField: key)
		}

		let stream = AIEventStream<ResponseType>(request: request, sslDelegate: sslDelegate)
		activeStreams.append(stream)

		return AsyncThrowingStream<AIStreamResponse<ResponseType>, Error> { continuation in
			Task(priority: .userInitiated) {
				var streamState = StreamTaskState()

				stream.onMessage { data, message in
					continuation.yield(AIStreamResponse(stream: stream, message: message, data: data))
				}

				stream.onComplete { _, forceEnd, error in
					streamState.isStreamFinished = true
					streamState.isStreamForceStop = forceEnd

					if let error {
						continuation.finish(throwing: error)
						return
					}

					continuation.yield(AIStreamResponse(stream: stream, message: nil, data: nil, isFinished: true, forceEnd: forceEnd))

					continuation.finish()
				}

				stream.startStream()

				continuation.onTermination = { @Sendable [weak self] _ in
					self?.terminateStream(stream)
				}
			}
		}
	}

	private func terminateStream<ResponseType: Decodable>(_ stream: AIEventStream<ResponseType>) {
		stream.stopStream()
		activeStreams.removeAll { $0 == stream }
	}
}
