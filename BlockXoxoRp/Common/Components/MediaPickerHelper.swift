import UIKit
import AVFoundation
import Photos

enum MediaPickerHelper {
    static func present(from vc: UIViewController, allowsEditing: Bool = true, completion: @escaping (UIImage?) -> Void) {
        BXDialog.show(on: vc, title: "Add Photo", message: "Choose camera or photo library.", confirmTitle: "Camera", cancelTitle: "Album", cancel: {
            open(from: vc, source: .photoLibrary, allowsEditing: allowsEditing, completion: completion)
        }, confirm: {
            open(from: vc, source: .camera, allowsEditing: allowsEditing, completion: completion)
        })
    }

    static func open(from vc: UIViewController, source: UIImagePickerController.SourceType, allowsEditing: Bool, completion: @escaping (UIImage?) -> Void) {
        if source == .camera {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                BXDialog.show(on: vc, message: "Camera is not available on this device.", confirmTitle: "Continue")
                return
            }
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                showPicker(from: vc, source: source, allowsEditing: allowsEditing, completion: completion)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { ok in
                    DispatchQueue.main.async {
                        if ok { showPicker(from: vc, source: source, allowsEditing: allowsEditing, completion: completion) }
                        else { guideToSettings(from: vc, feature: "camera") }
                    }
                }
            default:
                guideToSettings(from: vc, feature: "camera")
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized, .limited:
                showPicker(from: vc, source: source, allowsEditing: allowsEditing, completion: completion)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { s in
                    DispatchQueue.main.async {
                        if s == .authorized || s == .limited {
                            showPicker(from: vc, source: source, allowsEditing: allowsEditing, completion: completion)
                        } else {
                            guideToSettings(from: vc, feature: "photo library")
                        }
                    }
                }
            default:
                guideToSettings(from: vc, feature: "photo library")
            }
        }
    }

    private static func showPicker(from vc: UIViewController, source: UIImagePickerController.SourceType, allowsEditing: Bool, completion: @escaping (UIImage?) -> Void) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = allowsEditing
        let proxy = PickerProxy(completion: completion)
        picker.delegate = proxy
        objc_setAssociatedObject(picker, &Assoc.proxy, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        vc.present(picker, animated: true)
    }

    static func guideToSettings(from vc: UIViewController, feature: String) {
        BXDialog.show(on: vc, title: "Permission Needed", message: "Please enable \(feature) access in Settings to continue.", confirmTitle: "Open Settings", cancelTitle: "Cancel", confirm: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
    }

    static func saveImage(_ image: UIImage) -> String {
        let name = "local_\(UUID().uuidString.prefix(8))"
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Avatars", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("\(name).jpg")
        // Normalize orientation so JPEG encode is reliable for library/camera picks.
        let normalized = image.bx_normalized()
        if let data = normalized.jpegData(compressionQuality: 0.85) {
            try? data.write(to: url, options: .atomic)
        }
        ImageCache.shared.set(normalized, for: name)
        return name
    }

    static func loadLocal(_ name: String) -> UIImage? {
        if let img = ImageCache.shared.image(for: name) { return img }
        if let bundled = UIImage(named: name) { return bundled }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Avatars", isDirectory: true)
        let url = dir.appendingPathComponent("\(name).jpg")
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            ImageCache.shared.set(img, for: name)
            return img
        }
        return nil
    }

    static func ensureAVPermissions(from vc: UIViewController, completion: @escaping (Bool) -> Void) {
        let cam = AVCaptureDevice.authorizationStatus(for: .video)
        let mic = AVCaptureDevice.authorizationStatus(for: .audio)
        func checkMic(_ camOK: Bool) {
            switch mic {
            case .authorized: completion(camOK)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { ok in
                    DispatchQueue.main.async { completion(camOK && ok) }
                }
            default:
                guideToSettings(from: vc, feature: "microphone")
                completion(false)
            }
        }
        switch cam {
        case .authorized: checkMic(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { ok in
                DispatchQueue.main.async { checkMic(ok) }
            }
        default:
            guideToSettings(from: vc, feature: "camera")
            completion(false)
        }
    }
}

private enum Assoc { static var proxy = 0 }

private final class PickerProxy: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let completion: (UIImage?) -> Void
    init(completion: @escaping (UIImage?) -> Void) { self.completion = completion }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
        picker.dismiss(animated: true) { self.completion(img) }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { self.completion(nil) }
    }
}

final class ImageCache {
    static let shared = ImageCache()
    private var map: [String: UIImage] = [:]
    func set(_ image: UIImage, for key: String) { map[key] = image }
    func image(for key: String) -> UIImage? { map[key] }
}

extension UIImageView {
    func bx_avatar(_ name: String?) {
        if let name, let img = MediaPickerHelper.loadLocal(name) {
            image = img
        } else {
            image = UIImage(named: name ?? "avatar_01")
        }
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
