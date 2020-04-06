//
//  SCViewUtils.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import UIKit

class SCViewUtils: NSObject {
    
    class func gotoSettingsApp() {
        if #available(iOS 10.0, *) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Checking for setting is opened or not
                        print("Setting is opened: \(success)")
                    })
                }
            }
        }
    }
    
    /*
     returns rect value of table cell with respect to the view controller it is present
     */
    class func getRectOfCellInSuperView(inTableView tableView: UITableView, withIndex indexPath: IndexPath) -> CGRect {
        let rectOfCell = self.getRectOfCellInTableView(tableView, withIndex: indexPath)
        return tableView.convert(rectOfCell, to: tableView.superview)
    }
    
    /*
     returns rect value of table cell with respect to the tableview it is present
     */
    class func getRectOfCellInTableView(_ tableView: UITableView, withIndex indexPath: IndexPath) -> CGRect {
        return tableView.rectForRow(at: indexPath)
    }
    
    /*
     returns rect value of collection cell with respect to the view controller it is present
     */
    class func getRectOfCollectionCellInSuperView(inCollectionView collectionView: UICollectionView, withIndex indexPath: IndexPath) -> CGRect {
        let cellRect = self.getRectOfCollectionCellInCollectionView(collectionView, withIndex: indexPath)
        if #available(iOS 8.0, *) {
            return collectionView.convert(cellRect, to: collectionView.superview!)
        } else {
            return CGRect()
        }
    }
    
    /*
     returns rect value of collection cell with respect to the collectionview it is present
     */
    class func getRectOfCollectionCellInCollectionView(_ collectionView: UICollectionView, withIndex indexPath: IndexPath) -> CGRect {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        return attributes!.frame
    }
    
    //MARK: Validate Email
    class func isValidEmail(onController controller: UIViewController, email:String) -> Bool
    {
        let emailRegEx = "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email) == false
        {
            self.showAlertView(onController: controller, title: "Invalid Email", message: "Please enter a valid email.")
        }
        return emailTest.evaluate(with: email)
    }
    
    class func isValidMobile(testStr:String) -> Bool
    {
        if testStr.count == 10{
            return true
        }
        return false
        
    }
    
    //Use to show alertView without any action
    class func showAlertView(onController controller: UIViewController, title: String, message: String, actionTitle: String = "OK", actionStyle: UIAlertAction.Style = .default) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
        alertController.addAction(defaultAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    /*
     closure to add delay in viewcontrollers
     */
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
}

extension UIApplication {
    class func topmostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topmostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topmostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topmostViewController(base: presented)
        }
        return base
    }
}

@IBDesignable
extension UIView {
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return    UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            if let color = newValue?.cgColor {
                layer.borderColor = color
            }
        }
    }
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    @objc func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
    }
    
    /// To give drop shadow.
    func addElevation() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.2
    }
    
    // adds top shadow to views
    func topDropShadow(_ opacity: CGFloat = 0.3) {
        let shadowHeight: CGFloat = 5.0
        for subview in self.subviews {
            if (subview.tag == 100) {
                subview.removeFromSuperview()
            }
        }
        let topShadowView:UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.size.width, height: shadowHeight)))
        topShadowView.tag = 100
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let screenSize = UIScreen.main.bounds.size
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: shadowHeight)
        gradientLayer.colors = [UIColor.lightGray.withAlphaComponent(0).cgColor,UIColor.gray.withAlphaComponent(opacity).cgColor]
        topShadowView.layer.addSublayer(gradientLayer)
        self.addSubview(topShadowView)
        self.clipsToBounds = true
    }
    
    // Adds drop shadow only at bottom
    func dropShadow() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4.0
        let shadowRect: CGRect = self.bounds.insetBy(dx: 0, dy: 4)
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
    // adds bottom shadow with slight shadows on rest of the sides
    func bottomDropShadow() {
        self.layer.shadowOffset   = CGSize(width: 0, height: 1)
        self.layer.shadowColor    = UIColor.gray.cgColor
        self.layer.shadowRadius   = self.viewCornerRadius
        self.layer.shadowOpacity  = 0.3
        self.layer.masksToBounds  = false
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
    }
    
    // ideal for table view cell shadow
    func addShadowToTVCell(_ contentView : UIView) {
        //drop shadow and rounded corner
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7.0
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 2.5
    }
    
    // ideal for collection view cell shadow
    func addShadowToCVCell(_ contentView : UIView) {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.25
    }
    
    // animate uiview (curl down)
    func animateUI(_ childView: UILabel) {
        UIView.transition(from: self, to: childView, duration: 0.5, options: [.transitionCurlDown, .showHideTransitionViews, .allowUserInteraction], completion: nil)
    }
    
    func animateToggleAlpha(withDuration duration: Float = 0.5) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.alpha = self.alpha == 1 ? 0 : 1
        }
    }
    
    // rounded corners for view
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // add horizontal gradince to view
    @objc func addGradience(_ color1: String, _ color2: String) {
        self.addGradience(withColors: [UIColor.init(hexString: color1, alpha: 1.0).cgColor,
                                       UIColor.init(hexString: color2, alpha: 1.0).cgColor])
    }
    
    func addGradience(withColors colours: [CGColor],
                      withSPoint sPoint: CGPoint = CGPoint(x: 1, y: 0),
                      withEPoint ePoint: CGPoint = CGPoint(x: 0, y: 0),
                      withFrame viewFrame: CGRect? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colours
        
        gradientLayer.startPoint = sPoint
        gradientLayer.endPoint = ePoint
        
        if let vFrame = viewFrame {
            gradientLayer.frame = vFrame
        } else {
            gradientLayer.frame = self.bounds
        }
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.addSublayer(gradientLayer)
    }
    
    func setRoundedCorners(withRadius radius :CGFloat? = nil) {
        let cRadius = radius ?? self.bounds.height / 2.0
        self.layer.cornerRadius = cRadius
    }
    
    func setViewCornerWith(radius: CGFloat,hexString: String){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexString: hexString, alpha: 1.0).cgColor
        self.layer.cornerRadius = radius
    }
    
    // Recursive remove subviews and constraints
    func removeSubviews() {
        self.subviews.forEach({
            if !($0 is UILayoutSupport) {
                $0.removeSubviews()
                $0.removeFromSuperview()
            }
        })
    }
    
    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
    func removeTopLevelSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
    func transformView(withAngle angleFloat: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: ((angleFloat) / 180.0 * CGFloat(Double.pi)))
    }
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func containsSubView(ofKind kind: AnyClass) -> Bool {
        return self.subviews.reversed().contains{ $0.isKind(of: kind)}
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func  addGesture(){
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    func removeGesture()
    {
        if self.gestureRecognizers != nil
        {
            for gesture in self.gestureRecognizers! where gesture is UITapGestureRecognizer
            {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    
    /// Hide keyboard when user taps anywhere on the screen.
    @objc func hideKeyboard()
    {
        self.endEditing(true)
    }
}

extension UIImageView {
    
    /*
     Extension to change tint value of image set to imageView
     */
    func changeTint(withColor color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}


class HmeCustomTextField: UITextField {
    
    @IBInspectable var rightTextString : String? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightTextColor : UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let rt = rightTextString {
            let lblNew = HmePaddingLabel(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4))
            lblNew.text = rt
            lblNew.sizeToFit()
            lblNew.textColor = rightTextColor
            self.rightView = lblNew
            // select mode -> .never .whileEditing .unlessEditing .always
            self.rightViewMode = .always
        } else {
            self.rightViewMode = UITextField.ViewMode.never
            self.rightView = nil
        }
    }
}
extension UITextView {
    
    /// To calculate the number of lines of UITextView.
    ///
    /// - Returns: number of lines in UITextView.
    func getNumberOfLines() -> Int {
        let rawLineNumber = (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / (self.font?.lineHeight ?? 17.0)
        let finalLineNumber = round(rawLineNumber)
        return Int(finalLineNumber)
    }
}
extension UITextField {
    
    /*
     Add a toolbar with a done button above the number pad
     */
    func addDoneButton() {
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
                               UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(UITextField.resignFirstResponder)),
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        self.inputAccessoryView = keypadToolbar
    }
    
    func setCornerRadiusAndBorder(withColor hex: String) {
        self.layer.borderWidth = 1
        
        self.layer.borderColor = UIColor.init(hexString: hex, alpha: 1.0).cgColor
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.layer.sublayerTransform = CATransform3DMakeTranslation(self.bounds.height / 2.0, 0, 0);
    }
    
    func textFieldCheckIfValidFloat(whenChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        do {
            let nString = self.text as NSString?
            let newString = nString?.replacingCharacters(in: range, with: string)
            let expression = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
            let regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
            let numberOfMatches = regex.numberOfMatches(in: newString! as String, options: [], range: NSRange(location: 0, length: (newString?.count)!))
            
            if numberOfMatches == 0 {
                return false
            }
        }
        catch _ {
        }
        return true
    }
    
    func setImageToTextField(withImageName imageName: String,
                             withLeftFlag leftFlag: Bool = true,
                             withImageRotation rotationAngle :CGFloat = 0) {
        let tfHeight = self.bounds.height
        let rightView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: tfHeight))
        let rightImgView = UIImageView(frame: CGRect(x: 6, y: (tfHeight - 12)/2, width: 12, height: 12))
        rightImgView.center = rightImgView.center
        rightImgView.image = UIImage(named: imageName)
        rightImgView.transformView(withAngle: rotationAngle)
        rightView.addSubview(rightImgView)
        if leftFlag {
            self.leftView = rightView
            self.leftViewMode = .always
        } else {
            self.rightView = rightView
            self.rightViewMode = .always
        }
    }
    
    func addPadding(_ margin: CGFloat = 8.0) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: margin, height: 0.0))
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
}

extension UITableViewCell {
    
    static var xibName: String {
        return className
    }
}

extension UITableView {
    
    func register<C>(_ cellType: C.Type) where C: UITableViewCell {
        let name = String(describing: cellType.self)
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func reloadDataWithCompletion(completion: @escaping ()->()) {
        UIView.animate(withDuration: 1.5, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    /// To reload UITableView with completion handler.
    /// - Parameter completion: Callback when UITableView is loaded completely.
    func reloadDataWithClosure(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion()
        })
        self.reloadData()
        CATransaction.commit()
    }
}

// MARK:- Navigation controller
extension UINavigationController {
    
    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.
    
    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }
    
    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func getNavBarAndStatusHeight() -> CGFloat{
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
        return (self.navigationBar.frame.height + statusBarHeight)
    }
    
    public func popToRootViewController(animated: Bool,
                                        completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

class HmePaddingLabel: UILabel {
    
    let padding: UIEdgeInsets
    
    // Create a new PaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    // Create a new PaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }
    
    // Create a new PaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

extension UILabel {
    
    func boldRange(_ range: Range<String.Index>) {
        if let text = self.attributedText {
            let attr = NSMutableAttributedString(attributedString: text)
            let start = text.string.distance(from: text.string.startIndex, to: range.lowerBound)
            let length = text.string.distance(from: range.lowerBound, to: range.upperBound)
            attr.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)], range: NSMakeRange(start, length))
            self.attributedText = attr
        }
    }
    
    func boldSubstring(_ substr: String) {
        let range = self.text?.range(of: substr)
        if let r = range {
            boldRange(r)
        }
    }
    
    
    func setAnimatedText(text :String) {
        self.fadeOut(0.2, completion: {
            (finished: Bool) -> Void in
            self.text = text
            self.fadeIn(0.2)
        })
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font ?? SCFonts.defaultStandard(size: 16.0).value!], context: nil)
        let lines = Int(textSize.height/charSize)
        return lines
    }
    
    func calculateHeightForLabel(withWidth width: CGFloat, forFont font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return textSize.height
    }
    
    func changeColor(mainString: String,
                     stringToColor: String,
                     color: UIColor) {
        let range = (mainString as NSString).range(of: stringToColor)
        let attrString = NSMutableAttributedString(string:mainString)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        self.attributedText = attrString
    }
    
}

extension UIButton {
    
    func set(withImage image: UIImage? = nil, withTintColor tintColor: UIColor) {
        if let img = image  {
            let imageNew = img.withRenderingMode(.alwaysTemplate)
            self.setImage(imageNew, for: .normal)
            self.tintColor = tintColor
        }
    }
    
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension UISearchBar {
    
    var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator: UIActivityIndicatorView
                    if #available(iOS 13.0, *) {
                        newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    } else {
                        // Fallback on earlier versions
                        newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    }
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.white
                    newActivityIndicator.color = UIColor.black
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                DispatchQueue.main.async{
                    self.activityIndicator?.removeFromSuperview()
                }
            }
        }
    }
}

extension UIScrollView {
    
    func setContentViewSize(offset:CGFloat = 0.0) {
        // dont show scroll indicators
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        var maxHeight : CGFloat = 0
        for view in subviews {
            if view.isHidden {
                continue
            }
            let newHeight = view.frame.origin.y + view.frame.height
            if newHeight > maxHeight {
                maxHeight = newHeight
            }
        }
        // set content size
        contentSize = CGSize(width: contentSize.width, height: maxHeight + offset)
        // show scroll indicators
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true
    }
    
    func addSubViews(withViews svSubViews: [UIView], withItemSpacing itemSpacing: CGFloat = 8.0) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        var previousImageView: UIView?
        for (index, sView) in svSubViews.enumerated() {
            sView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(sView)
            if index == 0 {
                self.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: itemSpacing))
            } else {
                self.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: previousImageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: itemSpacing))
                
                if index == svSubViews.count - 1 {
                    self.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
                }
            }
            superview.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superview, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: sView.bounds.height))
            self.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            self.addConstraint(NSLayoutConstraint(item: sView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            previousImageView=sView
        }
    }
}

// Case incensitive keys for dictionary

extension Dictionary where Key : ExpressibleByStringLiteral {
    
    subscript(caseInsensitive key : Key) -> Value? {
        get {
            let searchKey = String(describing: key).lowercased()
            for k in self.keys {
                let lowerK = String(describing: k).lowercased()
                if searchKey == lowerK {
                    return self[k]
                }
            }
            return nil
        }
    }
}

extension UICollectionView {
    
    func register<C>(_ cellType: C.Type) where C: UICollectionViewCell {
        let name = String(describing: cellType.self)
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}

extension UICollectionViewCell {
    func scaleAnimateCell() {
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        
        let viewController = self.instantiateViewController(withIdentifier: T.className)
        guard let typedViewController = viewController as? T else {
            fatalError("Unable to cast view controller of type (\(type(of: viewController))) to (\(T.className))")
        }
        return typedViewController
    }
}

extension UIProgressView {
    
    func makeRoundedProgress() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.sublayers?[1].cornerRadius = 4
        self.subviews[1].clipsToBounds = true
    }
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UITabBarController {
    func createNavController(vc: UIViewController, unselected: UIImage, title: String) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.title = title
        return navController
    }
    
}


extension CGFloat {
    /// Returns string removing if self contains `0` after decimal point; Floating values are returned with 1 decimal points
    var roundOff: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}

extension Float {
    /// Returns string removing if self contains `0` after decimal point; Floating values are returned with 1 decimal points
    var roundOff: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}

extension Optional {
    
    func unwrapString() -> String {
        if let unwrapSelf = self as? String {
            return unwrapSelf
        }
        else {
            return ""
        }
    }
    
    func unwrapInt() -> Int {
        if let unwrapSelf = self as? Int {
            return unwrapSelf
        }
        else {
            return 0
        }
    }
    
    func unwrapObject(_ value: Wrapped) -> Wrapped {
        if let unwrapSelf: Wrapped = self {
            return unwrapSelf
        }
        else {
            return value
        }
    }
}

