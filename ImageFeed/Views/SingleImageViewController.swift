import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Public Properties

    var photo: Photo? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        loadImage()
    }

    // MARK: - Actions

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }

        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }

    // MARK: - Private Methods

    private func configureScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
    }

    private func loadImage() {
        guard
            let photo = photo,
            let url = URL(string: photo.largeImageURL)
        else { return }

        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }

            if case .success(let value) = result {
                self.imageView.frame.size = value.image.size
                self.rescaleAndCenterImage(value.image)
            }
        }
    }

    private func rescaleAndCenterImage(_ image: UIImage) {
        view.layoutIfNeeded()

        let visibleSize = scrollView.bounds.size
        let imageSize = image.size

        let widthScale = visibleSize.width / imageSize.width
        let heightScale = visibleSize.height / imageSize.height
        let scale = min(
            scrollView.maximumZoomScale,
            max(scrollView.minimumZoomScale, min(widthScale, heightScale))
        )

        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let contentSize = scrollView.contentSize
        let offsetX = (contentSize.width - visibleSize.width) / 2
        let offsetY = (contentSize.height - visibleSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
