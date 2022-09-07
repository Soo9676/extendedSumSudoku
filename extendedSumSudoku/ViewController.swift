//
//  MainViewController.swift
//  extendedSumSudoku
//
//  Created by Soo J on 2022/09/05.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sudokuCollectionView.delegate = self
        sudokuCollectionView.dataSource = self
        
        colSumsColllectionView.delegate = self
        colSumsColllectionView.dataSource = self
        
        rowSumCollectionView.delegate = self
        rowSumCollectionView.dataSource = self
        
        colSumsColllectionView.delegate = self
        colSumsColllectionView.dataSource = self
        
        resetData()
        sudokuCollectionView.reloadData()
        colSumsColllectionView.reloadData()
        
        configureScrollView()
        setupPicker()
    }
    
    @IBOutlet weak var settingsStack: UIStackView!
    @IBOutlet weak var settingRowLabel: UILabel!
    @IBOutlet weak var settingRowTextField: UITextField!
    @IBOutlet weak var settingColLabel: UILabel!
    @IBOutlet weak var settingColTextField: UITextField!
   
    @IBOutlet weak var sumSudokuScrollView: UIScrollView!
    
    @IBOutlet weak var sumSudokuView: UIView!
    @IBOutlet weak var sudokuCollectionView: UICollectionView!
    @IBOutlet weak var colSumsColllectionView: UICollectionView!
    @IBOutlet weak var rowSumCollectionView: UICollectionView!
    var minimumInterItemSpacing: CGFloat = 3
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    var sudokuRows: Int = 3
    var sudokuColums: Int = 3
    var numberOfRandomVal: Int = 3
    
    var sudokuData: [Int] = []
    var rowSumsData: [Int] = []
    var colSumsData: [Int] = []
    var randomValData: [Int] = []
    var randomIndexData: [Int] = []
//    var randomIndexDupYn = false
    
    let randomNumRange = 1...99
    let rowsRange = 2...99
    let columnsRange = 2...99
    
//    @IBAction func setNumberOfRows(_ sender: Any) {
//        appearPickerView()
//    }
//
//    @IBAction func setNumberOfColumns(_ sender: Any) {
//        appearPickerView()
//    }
//
    @IBAction func setNumberOfRow(_ sender: Any) {
        if let rowNum = Int(settingRowTextField.text ?? "3") {
            sudokuRows = rowNum
            print(sudokuRows)
        }
    }
    
    @IBAction func setNumberOfColumn(_ sender: Any) {
        if let colNum = Int(settingColTextField.text ?? "3") {
            sudokuColums = colNum
            print(sudokuColums)
        }
    }
    
    func setupPickerView() {
        let pickerView = UIPickerView()
            pickerView.delegate = self
    
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width:     UIScreen.main.bounds.width, height: 35))
        toolBar.sizeToFit()
            let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.done))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
    }
    
    @objc func done() {
        view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func configureScrollView() {
        sumSudokuScrollView.delegate = self
        sumSudokuScrollView.zoomScale = 1.0
        sumSudokuScrollView.minimumZoomScale = 1.0
        sumSudokuScrollView.maximumZoomScale = 2.0
    }
    
    @IBAction func tapStastButton(_ sender: Any) {
        resetData()
        placeRandomVal()
    }
    
    @IBAction func tapCompleteButton(_ sender: Any) {
        
    }
    
    func resetData() {
        sudokuData = []
        rowSumsData = []
        colSumsData = []
        
        for _ in 0..<sudokuRows {
            rowSumsData.append(0)
        }
        for _ in 0..<sudokuColums {
            colSumsData.append(0)
        }
        for _ in 0..<(sudokuRows*sudokuColums) {
            sudokuData.append(0)
        }
    }
    
    func createRandomVal() ->Int {
        return Int.random(in: randomNumRange)
    }
    
    func createRandomIndex() -> Int {
        return Int.random(in: 0...(sudokuRows*sudokuColums - 1))
    }
    
    func checkDuplicate(arr: [Int]) -> Bool {
        return Set(arr).count == arr.count
    }
    
    func placeRandomVal() {
        for _ in randomNumRange {
            randomValData.append(createRandomVal())
            randomIndexData.append(createRandomIndex())
            if checkDuplicate(arr: randomIndexData) {
                for i in 0...(numberOfRandomVal - 1) {
                    sudokuData[randomIndexData[i]] = randomValData[i]
                }
            }
            
        }
    }
    
    
}
//MARK: PickerView 관련
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPicker() {
         
    }
    
    func appearPickerView() {
        UIView.animate(withDuration: 0.3, animations: {self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.height - self.pickerView.bounds.size.height, width: self.pickerView.bounds.size.width, height: self.pickerView.bounds.size.height)
        })
    }
    
    func disappearPickerView() {
        UIView.animate(withDuration: 0.3, animations: {self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.pickerView.bounds.size.width, height: self.pickerView.bounds.size.height)
        })
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return rowsRange.count
        case 1:
            return columnsRange.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row + 1) Rows"
        case 1:
            return "\(row + 1) Colums"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            sudokuRows = row + 1
        case 1:
            sudokuColums = row + 1
        default:
            break
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case sudokuCollectionView:
            return sudokuData.count
        case colSumsColllectionView:
            return colSumsData.count
        case rowSumCollectionView:
            return rowSumsData.count
        default:
            return 0
        }
        
    }
    //MARK: Colllection CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case sudokuCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SudokuCollectionViewCell {
                cell.numberLabel.text = "sudoku \(indexPath.row)"
                return cell
            }
        case colSumsColllectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColSumsCollectionViewCell {
                cell.colSumLabel.text = "Col \(indexPath.row)"
                return cell
            }
        case rowSumCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RowSumsCollecionViewCell {
                cell.rowSumLabel.text = "Row\(indexPath.row)"
                return cell
            }
        default:
            return UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    //MARK: Collection SizeForItem
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case sudokuCollectionView:
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            let rows = CGFloat(self.sudokuRows)
            let colummns = CGFloat(self.sudokuColums)
            
            let cellWidth = (width - 3*(colummns - 1))/colummns - 1
            let cellHeight = (height - 3*(rows - 1))/rows - 1
            
            return CGSize(width: cellWidth, height: cellHeight)
        case colSumsColllectionView:
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            let rows = CGFloat(self.sudokuRows)
            let colummns = CGFloat(self.sudokuColums)
            
            let cellWidth = (width - 3*(colummns - 1))/colummns - 1
            let cellHeight = height
            
            return CGSize(width: cellWidth, height: cellHeight)
            
        case rowSumCollectionView:
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            let rows = CGFloat(self.sudokuRows)
            let colummns = CGFloat(self.sudokuColums)
            
            let cellWidth = width
            let cellHeight = (height - 3*(rows - 1))/colummns - 1
            
            return CGSize(width: cellWidth, height: cellHeight)
            
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let spacing = minimumInterItemSpacing
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacing = minimumInterItemSpacing
        return spacing
    }
}
