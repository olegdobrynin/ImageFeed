import UIKit

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let urls: UrlResult
    var likedByUser: Bool
}

struct UrlResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

final class ImagesListService {
    
    // MARK: - Singleton
    
    static let shared = ImagesListService()
    private init() {}

    // MARK: - Public Properties

    private(set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private var lastLoadedPage: Int = 0
    private var task: URLSessionTask?

    // MARK: - Public Methods

    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage + 1
        
        guard let request = makePhotosRequest(page: nextPage)
        else {
            print("ImagesListService.fetchPhotosNextPage request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    let newPhotos = result.map { Photo(from: $0) }
                    self?.photos.append(contentsOf: newPhotos)
                    self?.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object:
                            self
                    )
                case .failure(let error):
                    print("fetchPhotosNextPage error \(error.localizedDescription)")
                }
                self?.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Network Requests
    private func makePhotosRequest(page: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard
            let url = components.url
        else {
            print("ImagesListService.makePhotosRequest Photos")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    // MARK: - Likes
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let request: URLRequest?
        
        if isLike {
            request = makeLikeRequest(id: photoId)
        } else {
            request = makeUnLikeRequest(id: photoId)
        }
        
        guard let request = request else {
            let error = NSError(domain: "ImageFeed", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create like/unlike request"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                completion(.success(()))
                
            case .failure(let error):
                if case NetworkError.httpStatusCode(let code) = error {
                    print("HTTP Error: \(code)")
                }
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeLikeRequest(id: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(id)/like")
        else {
            print("ImagesListService.makeLikeRequest like url error")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let token = OAuth2TokenStorage.shared.token else {
            print("makeLikeRequest authtoken not found")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeUnLikeRequest(id: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(id)/like")
        else {
            print("ImagesListService.makeUnlikeRequest dislike error")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        guard let token = OAuth2TokenStorage.shared.token else {
            print("makeUnlikeRequest auth token not found")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}


// MARK: - Logout

extension ImagesListService {
    func exitImagesListService() {
        self.photos = []
        self.task = nil
        self.lastLoadedPage = 0
    }
}
