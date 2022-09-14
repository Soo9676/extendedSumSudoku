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
        navigationController?.isNavigationBarHidden = true
        sudokuCollectionView.delegate = self
        sudokuCollectionView.dataSource = self
        
        colSumsColllectionView.delegate = self
        colSumsColllectionView.dataSource = self
        
        rowSumCollectionView.delegate = self
        rowSumCollectionView.dataSource = self
        
        colSumsColllectionView.delegate = self
        colSumsColllectionView.dataSource = self
        
        resetData()
        reloadCollectionViews()
        sudokuCollectionView.reloadData()
        rowSumCollectionView.reloadData()
        colSumsColllectionView.reloadData()
        
        
        configureScrollView()
        
        settingRowTextField.keyboardType = UIKeyboardType.numberPad
        settingRowTextField.keyboardAppearance = UIKeyboardAppearance.default
        settingRowTextField.returnKeyType = UIReturnKeyType.done
        settingRowTextField.enablesReturnKeyAutomatically = true
        
        settingColTextField.keyboardType = UIKeyboardType.numberPad
        settingColTextField.keyboardAppearance = UIKeyboardAppearance.default
        settingColTextField.returnKeyType = UIReturnKeyType.done
        settingColTextField.enablesReturnKeyAutomatically = true
    }
    
    @IBOutlet weak var settingsStack: UIStackView!
    @IBOutlet weak var settingRowLabel: UILabel!
    @IBOutlet weak var settingRowTextField: UITextField!
    @IBOutlet weak var settingColLabel: UILabel!
    @IBOutlet weak var settingColTextField: UITextField!
    @IBOutlet weak var settingSizeButton: UIButton!
    
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
    var isSumMatch: Bool = false
    var isZeroExists: Bool = true
//    var randomIndexDupYn = false
    
    let randomNumRange = 1...99
    let rowsRange = 2...99
    let columnsRange = 2...99
    let inputRange = 1...99
    
    @IBAction func setSizeOfSudoku(_ sender: Any) {
        if let rowNum = Int(settingRowTextField.text ?? "3"), let colNum = Int(settingColTextField.text ?? "3"){
            sudokuRows = rowNum
            print("Row: \(sudokuRows)")
            sudokuColums = colNum
            print("Col: \(sudokuColums)")
            
        }
        
        resetData()
        reloadCollectionViews()
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
    
    @IBAction func tapStartButton(_ sender: Any) {
//        showResultAlert()
        resetData()
        placeRandomVal()
        updateSumsData()
        reloadCollectionViews()
        
    }
    
    @IBAction func tapCompleteButton(_ sender: Any) {
        compareSums(rowSums: rowSumsData, colSums: colSumsData)
        showResultAlert()
    }
    
    func resetData() {
        resetSudokuData()
        resetSumsData()
    }
    
    func resetSudokuData() {
        sudokuData = []
        for _ in 0..<(sudokuRows*sudokuColums) {
            sudokuData.append(0)
        }
    }
    
    func resetSumsData() {
        rowSumsData = []
        colSumsData = []
        for _ in 0..<sudokuRows {
            rowSumsData.append(0)
        }
        for _ in 0..<sudokuColums {
            colSumsData.append(0)
        }
    }
    
    func reloadCollectionViews() {
        sudokuCollectionView.reloadData()
        rowSumCollectionView.reloadData()
        colSumsColllectionView.reloadData()
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
    
    func resetRandomData() {
        randomValData = []
        randomIndexData = []
    }
    
    func updateSumsData() {
        resetSumsData()
        //TODO: 반복 쵀적화
        var lastSudokuIndex = sudokuData.count - 1
        var lastRowIndex = rowSumsData.count - 1
        var lastColIndex = colSumsData.count - 1
         
        for j in 0...lastRowIndex {
            for i in 0...lastSudokuIndex {
                if i/sudokuColums == j {
                    rowSumsData[j] += sudokuData[i]
                }
            }
        }
        
        for k in 0...lastColIndex {
            for i in 0...lastSudokuIndex {
                if i%sudokuColums == k {
                    colSumsData[k] += sudokuData[i]
                }
            }
        }
        print("rowSums=\(rowSumsData)")
        print("colSums=\(colSumsData)")
    }
        

    
    func placeRandomVal() {
        resetRandomData()
        for _ in 1...numberOfRandomVal {
            randomValData.append(createRandomVal())
            randomIndexData.append(createRandomIndex())
        }
        print("randomValData = \(randomValData)")
        print("randomIndexData = \(randomIndexData)")
        
        if checkDuplicate(arr: randomIndexData) {
            for i in 0...(numberOfRandomVal - 1) {
                sudokuData[randomIndexData[i]] = randomValData[i]
            }
        } else {
            placeRandomVal()
        }
        
        print("sudokuData = \(sudokuData)")
    }
    
    func compareSums(rowSums: [Int], colSums: [Int]) -> Bool {
        
        for i in 0...(rowSums.count - 2) {
            if rowSums[i] == rowSums[i+1] {
                isSumMatch = true
            } else {
                isSumMatch = false
                return isSumMatch
            }
        }
        
        for i in 0...(colSums.count - 2) {
            if colSums[i] == colSums[i+1] {
                isSumMatch = true
            } else {
                isSumMatch = false
                return isSumMatch
            }
        }
        return isSumMatch
    }
    
    func showResultAlert(){
        compareSums(rowSums: rowSumsData, colSums: colSumsData)
        
        if sudokuData.contains(0) {
            let alert = UIAlertController(title: "경고", message: "아직 모든 숫자 입력 안됨\n버튼을 눌러 새게임을 시작하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: tapStartButton(_:))
            let cancelAction = UIAlertAction(title: "아직 아님", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: false, completion: nil)
        } else if isSumMatch == true {
            let alert = UIAlertController(title: "성공", message: "가로세로 합 맞추기 성공", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let alert = UIAlertController(title: "실패", message: "가로세로 합 맞추기 실패\n리셋하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "새로", style: .destructive, handler: tapStartButton(_:))
            let cancelAction = UIAlertAction(title: "이어서", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: false, completion: nil)
        }
    }
}

//MARK: custom delegate
extension MainViewController: UpdatingValue {
    func updateValue(index: Int, value: Int) {
        sudokuData[index] = value //update sudoku data
        updateSumsData()
        reloadCollectionViews()
    }
}

//MARK: Colllection Views
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case sudokuCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SudokuCollectionViewCell {
                cell.delegate = self
                cell.totalCellCount = sudokuColums*sudokuRows
                cell.numberTextField.isHidden = false
                cell.numberLabel.text = "\(sudokuData[indexPath.row])"
                
//                var isItGivenNumber: Bool = false...
//                게임 시작시 주어진 배치된 세개의 값인지 확인
                if let textInCell = cell.numberLabel.text {
                    if let numberInCell = Int(textInCell){
                        if randomIndexData.contains(indexPath.row)/*, sudokuData[indexPath.row] == sudokuData.firstIndex(of: numberInCell)*/ {
                            cell.numberTextField.isHidden = true
                        }
                    }
                }
                cell.numberTextField.isUserInteractionEnabled = true
                
                cell.index = indexPath.row
                cell.numberTextField.keyboardType = UIKeyboardType.numberPad
                cell.numberTextField.keyboardAppearance = UIKeyboardAppearance.default
                cell.numberTextField.returnKeyType = UIReturnKeyType.done
                cell.numberTextField.enablesReturnKeyAutomatically = true // 리턴키 자동 활성화 On
                return cell
            }
        case colSumsColllectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColSumsCollectionViewCell {
                cell.colSumLabel.text = "\(colSumsData[indexPath.row])"
                return cell
            }
        case rowSumCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RowSumsCollecionViewCell {
                cell.rowSumLabel.text = "\(rowSumsData[indexPath.row])"
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
            let cellHeight = (height - 3*(rows - 1))/rows - 1
            
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
