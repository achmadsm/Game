//
//  File.swift
//
//
//  Created by + on 3/7/1446 AH.
//

import Alamofire
import Combine
import Core
import Foundation

public struct GetGameRemoteDataSource: DataSource {
  public typealias Request = String

  public typealias Response = GameResponse

  private let endpoint: String

  public init(endpoint: String) {
    self.endpoint = endpoint
  }

  public func execute(request: Request?) -> AnyPublisher<Response, Error> {
    return Future<GameResponse, Error> { completion in

      guard let request = request else { return completion(.failure(URLError.invalidRequest)) }

      if let url = URL(string: self.endpoint + request) {
        AF.request(url)
          .validate()
          .responseDecodable(of: GamesResponse.self) { response in
            switch response.result {
            case let .success(value):
              completion(.success(value.results[0]))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
}
