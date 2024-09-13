//
//  File.swift
//
//
//  Created by + on 3/7/1446 AH.
//

import Combine
import Core
import Foundation

public class GamePresenter<
  GameUseCase: UseCase,
  FavoriteUseCase: UseCase
>: ObservableObject where

  GameUseCase.Request == Int,
  GameUseCase.Response == GameModel,
  FavoriteUseCase.Request == Int,
  FavoriteUseCase.Response == GameModel {
  private var cancellables: Set<AnyCancellable> = []

  private let gameUseCase: GameUseCase
  private let favoriteUseCase: FavoriteUseCase

  @Published public var item: GameModel?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false

  public init(gameUseCase: GameUseCase, favoriteUseCase: FavoriteUseCase) {
    self.gameUseCase = gameUseCase
    self.favoriteUseCase = favoriteUseCase
  }

  public func getGame(request: GameUseCase.Request) {
    isLoading = true
    gameUseCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { item in
        self.item = item
      })
      .store(in: &cancellables)
  }

  public func updateFavoriteGame(request: FavoriteUseCase.Request) {
    favoriteUseCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { item in
        self.item = item
      })
      .store(in: &cancellables)
  }
}
