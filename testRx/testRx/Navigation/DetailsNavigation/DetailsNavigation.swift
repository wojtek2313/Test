//
//  DetailsNavigation.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import Foundation
import UIKit

// MARK: - Enum Definition

public enum DetailsNavigationType: String {
    case details
}

// MARK: - Class Definition

class DetailsNavigationRouter: NavigationRouter<ShopItemServiceProtocol, DetailsNavigationType> {
    override func navigate(to routeID: RouteID, from context: UIViewController, withParameters parameters: Parameters?) {
        switch routeID {
        case .details:
            guard let parameters = parameters else { return }
            let viewModel = DetailsViewModel(shopItemService: parameters)
            let viewController = DetailsViewController(viewModel: viewModel)
            context.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
