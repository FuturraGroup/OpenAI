//
//  Extensions.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

extension JSONDecoder {
	static var aiDecoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .millisecondsSince1970

		return decoder
	}
}

extension JSONEncoder {
	static var aiEncoder: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}
}
