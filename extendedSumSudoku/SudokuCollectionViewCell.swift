//
//  SudokuCollectionCell.swift
//  extendedSumSudoku
//
//  Created by Soo J on 2022/09/06.
//

import Foundation
import UIKit

protocol UpdatingValue {
    func updateValue(index: Int, value: Int)
}

class SudokuCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    var totalCellCount: Int = 9
    var index: Int?
    var delegate: UpdatingValue?
    var currentInput: Int?
    var inputRange = 1...200
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let input = Int(textField.text ?? "0")
        if let input = input {
            if inputRange.contains(Int(input)) {
                currentInput = Int(input)
                if let index = index, let currentInput = currentInput {
                    delegate?.updateValue(index: index, value: currentInput)
                    self.numberTextField.text = ""
                }
            } else {
                //입력범위 경고창 띄우기
                return
            }
        }
    }
}
