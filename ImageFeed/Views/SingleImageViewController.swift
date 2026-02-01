
import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Public Properties

    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            updateImage()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        updateImage()
    }

    // MARK: - Actions

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }

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
    }

    private func updateImage() {
        guard let image else { return }

        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImage(image)
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
