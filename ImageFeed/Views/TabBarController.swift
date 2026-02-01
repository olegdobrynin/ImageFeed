import UIKit
 
final class TabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    // MARK: - Private Methods

    private func setupViewControllers() {
        viewControllers = [
            makeImagesListViewController(),
            makeProfileViewController()
        ]
    }

    private func makeImagesListViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
    }

    private func makeProfileViewController() -> UIViewController {
        let viewController = ProfileViewController()
        viewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        return viewController
    }
}
