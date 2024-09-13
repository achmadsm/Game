//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

import Alamofire
import Combine
import Core
import Foundation

public struct GetGamesRemoteDataSource: DataSource {
  public typealias Request = String

  public typealias Response = [GameResponse]

  private let _endpoint: String

  public init(endpoint: String) {
    _endpoint = endpoint
  }

  public func execute(request: String?) -> AnyPublisher<Response, Error> {
    return Future<[GameResponse], Error> { completion in
                                          
      if let url = URL(string: _endpoint + (request ?? "")) {
        AF.request(url)
          .validate()
          .responseDecodable(of: GamesResponse.self) { response in
            switch response.result {
            case let .success(value):
              completion(.success(value.results))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
}
