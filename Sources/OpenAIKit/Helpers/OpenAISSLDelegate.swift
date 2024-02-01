//
//  OpenAISSLDelegate.swift
//  OpenAIKit
//
//  Created by Kyrylo Mukha on 31.01.2024.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
final class OpenAISSLDelegate: NSObject {
	private let sslCerificatePath: String?

	init(sslCerificatePath: String?) {
		self.sslCerificatePath = sslCerificatePath
	}
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension OpenAISSLDelegate: URLSessionDelegate {
	public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
			completionHandler(.useCredential, nil)
			return
		}

		guard let sslCerificatePath else {
			let credential = URLCredential(trust: serverTrust)
			completionHandler(.useCredential, credential)
			return
		}

		let policy = NSMutableArray()
		policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

		let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)

		let remoteCertificateData: NSData = SecCertificateCopyData(certificate)

		guard let localCertificateData = NSData(contentsOfFile: sslCerificatePath) else {
			completionHandler(.cancelAuthenticationChallenge, nil)
			return
		}

		if isServerTrusted, remoteCertificateData.isEqual(to: localCertificateData as Data) {
			let credential = URLCredential(trust: serverTrust)
			completionHandler(.useCredential, credential)
		} else {
			completionHandler(.cancelAuthenticationChallenge, nil)
		}
	}
}
