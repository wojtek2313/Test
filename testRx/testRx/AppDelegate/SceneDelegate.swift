//
//  SceneDelegate.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Public Properties
    
    var window: UIWindow?
    var navigationController: UINavigationController?

    // MARK: - App Liftime Methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        startAppFlow(at: scene)
    }
    
    // MARK: - Private Methods
    
    private func startAppFlow(at scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
        navigationController = UINavigationController(rootViewController: createMainViewController())
        navigationController?.isNavigationBarHidden = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func createMainViewController() -> UIViewController {
        let detailsNavigationRouter = DetailsNavigationRouter()
        let responseFactory = ResponseFactory()
        let shopBasketBuilder = ShopBasketBuilder()
        let shopCatalogItemStrategy = ShopCatalogItemStrategy(shopBasketBuilder: shopBasketBuilder)
        let shopBasketItemStrategy = ShopBasketItemStrategy(shopBasketBuilder: shopBasketBuilder)
        let viewModel = MainViewModel(catalog: shopCatalogItemStrategy, basket: shopBasketItemStrategy, responseFactory: responseFactory)
        let viewController = MainViewController(viewModel: viewModel, router: detailsNavigationRouter)
        return viewController
    }
}

