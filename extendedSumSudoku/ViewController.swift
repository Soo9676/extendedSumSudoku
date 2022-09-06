//
//  MainViewController.swift
//  extendedSumSudoku
//
//  Created by Soo J on 2022/09/05.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sudokuCollectionView.delegate = self
        sudokuCollectionView.dataSource = self
//        sudokuCollectionView.register(SudokuCollectionViewCell.self, forCellWithReuseIdentifier: "cell'")
        
        rowSumsTableView.delegate = self
        rowSumsTableView.dataSource = self
        
        colSumsColllectionView.delegate = self
        colSumsColllectionView.dataSource = self
//        colSumsColllectionView.register(ColSumsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        resetData()
        sudokuCollectionView.reloadData()
        rowSumsTableView.reloadData()
        colSumsColllectionView.reloadData()
        
        configureScrollView()
    }
    
    @IBOutlet weak var settingsStack: UIStackView!
    @IBOutlet weak var settingRowLabel: UILabel!
    @IBOutlet weak var settingRowButton: UIButton!
    @IBOutlet weak var settingColLabel: UILabel!
    @IBOutlet weak var settingColButton: UIButton!
   
    @IBOutlet weak var sumSudokuScrollView: UIScrollView!
    
    @IBOutlet weak var sumSudokuView: UIView!
    @IBOutlet weak var sudokuCollectionView: UICollectionView!
    @IBOutlet weak var rowSumsTableView: UITableView!
    @IBOutlet weak var colSumsColllectionView: UICollectionView!
    var minimumInterItemSpacing: CGFloat = 3
    
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

extension MainViewController: UIScrollViewDelegate {
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sudokuCollectionView {
            return sudokuData.count
        } else if collectionView == colSumsColllectionView {
            return colSumsData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sudokuCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SudokuCollectionViewCell {
                cell.numberLabel.text = "sudoku \(indexPath.row)"
                return cell
            }
            
        } else if collectionView == colSumsColllectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColSumsCollectionViewCell {
                cell.colSumLabel.text = "Col \(indexPath.row)"
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sudokuCollectionView {
            let width = Int(collectionView.frame.width)
            let height = Int(collectionView.frame.height)
            let rows = self.sudokuRows
            let colummns = self.sudokuColums
            
            let cellWidth = (width - 3*(colummns - 1))/colummns
            let cellHeight = (height - 3*(rows - 1))/rows
            
            return CGSize(width: cellWidth, height: cellHeight)
        } else if collectionView == colSumsColllectionView {
            let width = Int(collectionView.frame.width)
            let height = Int(collectionView.frame.height)
//            let rows = self.sudokuRows
            let colummns = self.sudokuColums
            
            let cellWidth = (width - 3*(colummns - 1))/colummns
            let cellHeight = height
            
            return CGSize(width: cellWidth, height: cellHeight)
        }

        return CGSize(width: 0, height: 0)
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowSumsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RowSumCell", for: indexPath) as? RowSumsTableViewCell {
            cell.rowSumLabel.text = "Row\(indexPath.row)"
            return cell
        }
        return UITableViewCell()
    }
    
    
}
