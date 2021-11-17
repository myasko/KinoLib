//
//  FormController.swift
//  test_project2
//
//  Created by Артем on 14.11.2021.
//

import UIKit

class FormViewController: UIViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override func loadView() {
        super.loadView()
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    func createTextField(placeholder: String, secure: Bool = false) -> UITextField {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.placeholder = placeholder
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.keyboardType = UIKeyboardType.default
        field.isUserInteractionEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        
        if (secure) {
            field.isSecureTextEntry = true
        }
        
        return field
    }
    
    func createButton(title: String, asLabel: Bool = false) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.orange, for: .highlighted)
        
        if (!asLabel) {
            btn.setTitleColor(.black, for: .normal)
            btn.layer.borderWidth = 1.0
            btn.layer.cornerRadius = 4.0
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
