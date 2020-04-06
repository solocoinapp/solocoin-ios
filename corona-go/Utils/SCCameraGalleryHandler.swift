//
//  SCCameraGalleryHandler.swift
//  corona-go
//
//  Created by indie dev on 02/04/20.
//

import UIKit


protocol PhotoCameraGalleryHandlerProtocol: class {
    func didUploadImage(_ uploadedImage: UIImage)
}

class SCCameraGalleryHandler: NSObject  {
    
    //MARK:- Variables
    weak var delegate: PhotoCameraGalleryHandlerProtocol?
    weak var viewController: UIViewController?
    private var selfRefrence: SCCameraGalleryHandler?

    //MARK:- init Methods
    init(onViewController vc: UIViewController?, titleText:String?, galleryText: String?, cameraText: String?) {
        self.viewController = vc
        super.init()
        
        self.openActionSheet(withTitleText: titleText,galleryText: galleryText, cameraText: cameraText)
    }
    
    /// To open action sheet for making selection to upload photo.
    /// - Parameters:
    ///   - titleText: Text which needs to be displayed as action sheet header title.
    ///   - galleryText: Text which needs to be displayed as gallery option.
    ///   - cameraText: Text which needs to be displayed as camera option.
    private func openActionSheet(withTitleText titleText: String?, galleryText: String?, cameraText: String?) {
        var titleTxt = "UPLOAD_IMAGE".localized()
        var galleryTxt = "CHOOSE_PHOTOS".localized()
        var cameraTxt = "CLICK_PICTURE".localized()
        
        if let _titleText = titleText, !_titleText.isEmpty{
            titleTxt = _titleText
        }
        if let _galleryText = galleryText, !_galleryText.isEmpty{
            galleryTxt = _galleryText
        }
        if let _cameraText = cameraText, !_cameraText.isEmpty{
            cameraTxt = _cameraText
        }
        
        let alertController = UIAlertController(title: titleTxt, message: nil, preferredStyle: .actionSheet)
        let pickFromGalleryAction = UIAlertAction(title: galleryTxt, style: .default) { (action) in
            self.openPhotoLibrary()
        }
        let clickPhotoAction = UIAlertAction(title: cameraTxt, style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        
        alertController.addAction(pickFromGalleryAction)
        alertController.addAction(clickPhotoAction)
        alertController.addAction(cancelAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// When user selects camera option from action sheet.
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            selfRefrence = self
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /// When user selects gallery option from action sheet.
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            selfRefrence = self
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate Methods
extension SCCameraGalleryHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            delegate?.didUploadImage(selectedImage)
            viewController?.dismiss(animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.selfRefrence = nil
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.selfRefrence = nil
        }
    }
}

func _max<T: Comparable>(a: T, b: T) -> T {
    return max(a, b)
}

func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
