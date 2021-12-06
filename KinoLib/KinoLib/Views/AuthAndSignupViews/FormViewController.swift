//
//  FormController.swift
//  test_project2
//
//  Created by Артем on 14.11.2021.
//

import UIKit

class CustomTextField: UITextField {
    struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}

class FormViewController: UIViewController {
    var backgroundColor1: UIColor!
    var backgroundColor2: UIColor!
    var highlightColor: UIColor!
    var textColor: UIColor!
    var placeholderColor: UIColor!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override func loadView() {
        super.loadView()
        
        let c = Colors()
        backgroundColor1 = c.background1
        backgroundColor2 = c.background2
        highlightColor =  c.highlight
        textColor = c.text
        placeholderColor = c.placeholder
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = backgroundColor1
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = backgroundColor1
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    func createTextField(placeholder: String, secure: Bool = false) -> UITextField {
        let field = CustomTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = UIKeyboardType.default
        field.isUserInteractionEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.textColor = textColor
        
        field.layer.borderWidth = 1.0
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 4.0
        field.layer.borderColor = highlightColor.cgColor
        
        field.backgroundColor = backgroundColor2
        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        if (secure) {
            field.isSecureTextEntry = true
        }
        
        return field
    }
    
    func createButton(title: String, asLabel: Bool = false) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(highlightColor, for: .normal)
        btn.setTitleColor(textColor, for: .highlighted)
        
        if (!asLabel) {
            btn.setTitleColor(textColor, for: .normal)
            btn.backgroundColor = highlightColor
            btn.layer.borderWidth = 1.0
            btn.layer.cornerRadius = 4.0
            btn.layer.borderColor = highlightColor.cgColor
        }
        
        return btn
    }
    
    func createAlert(title: String, message: String, buttonTitle: String = "OK", handler: (() -> ())? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {
            _ in
            if (handler != nil) {
                handler!()
            }
        }))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMain() {
        let mainViewController = MainViewController()
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
