//
//  TextFieldExtension.swift
//  Trough_Driver
//
//  Created by Imed on 17/02/2021.
//

import UIKit

extension UITextField{
    
    func isTextFieldEmpty() -> Bool
          {
            return self.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty ?? true
          }
    
    func isEmailValid() -> Bool {
               let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
               let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
               return emailPredicate.evaluate(with: self.text)
                 
             }
    func isPasswordTextFieldValid() -> Bool {
               let passwordFormat = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
               let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
               return passwordPredicate.evaluate(with: self.text)
                 
             }

    func isValidPassword(password: String) -> Bool {
            let passwordRegex = "^(?=.*?[0-9]).{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    
}
