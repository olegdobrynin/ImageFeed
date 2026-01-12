import UIKit

final class ProfileViewController: UIViewController {

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        addAvatarImageView()
        addLogoutButton()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()

    }

    @IBAction private func didTapLogoutButton() {}

    private func addAvatarImageView() {
        avatarImageView.image = UIImage(named: "ProfileImage")
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)

        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive =
            true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive =
            true
        avatarImageView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        ).isActive = true
        avatarImageView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        ).isActive = true

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
    }

    private func addLogoutButton() {
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.addTarget(
            self,
            action: #selector(Self.didTapLogoutButton),
            for: .touchUpInside
        )
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive =
            true
        logoutButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16
        ).isActive = true
        logoutButton.centerYAnchor.constraint(
            equalTo: avatarImageView.centerYAnchor
        ).isActive = true
    }

    private func addNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        nameLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        ).isActive = true
        nameLabel.topAnchor.constraint(
            equalTo: avatarImageView.bottomAnchor,
            constant: 8
        ).isActive = true
    }

    private func addLoginLabel() {
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)

        loginLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        ).isActive = true
        loginLabel.topAnchor.constraint(
            equalTo: nameLabel.bottomAnchor,
            constant: 8
        ).isActive = true
    }

    private func addDescriptionLabel() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        descriptionLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        ).isActive = true
        descriptionLabel.topAnchor.constraint(
            equalTo: loginLabel.bottomAnchor,
            constant: 8
        ).isActive = true
    }

}
