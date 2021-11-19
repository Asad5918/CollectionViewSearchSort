//
//  ViewController.swift
//  CollectionViewSearchSort
//
//  Created by ebsadmin on 10/11/21.
//  Copyright © 2021 droisys. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    lazy var searchBar: UISearchBar = UISearchBar()
    var selectedImage = UIImage()
    var nameAndImageArray = [[String: Any]]()
    var filteredArray = [[String: Any]]()
    var dict: [String : Any] = [
        "Name" : "",
        "Image": ""
    ]
    var selectedCellIndexPath = 0
    var searchString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search"
//        nameAndImageArray = [
//            [
//            "Name" : "Kim",
//            "Image": UIImage(named: "Profile1")!
//            ],
//            [
//                "Name" : "Sara",
//                "Image": UIImage(named: "Profile2")!
//            ],
//            [
//                "Name" : "Tom",
//                "Image": UIImage(named: "Profile3")!
//            ],
//            [
//                "Name" : "John",
//                "Image": UIImage(named: "Profile4")!
//            ],
//        ]
//
//        filteredArray = [
//            [
//                "Name" : "Kim",
//                "Image": UIImage(named: "Profile1")!
//            ],
//            [
//                "Name" : "Sara",
//                "Image": UIImage(named: "Profile2")!
//            ],
//            [
//                "Name" : "Tom",
//                "Image": UIImage(named: "Profile3")!
//            ],
//            [
//                "Name" : "John",
//                "Image": UIImage(named: "Profile4")!
//            ],
//        ]
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        let object = filteredArray[indexPath.row]
        cell.imageView.image = object["Image"] as? UIImage
        cell.photoName.text = object["Name"] as? String
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        filteredArray.insert(filteredArray[indexPath.row], at: 0)
//        filteredArray.remove(at: indexPath.row + 1)
//        collectionView.reloadData()
        selectedCellIndexPath = indexPath.row
        showAlert("Enter name")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let numberOfCellsInRow: CGFloat = 3.0
        let width = (collectionView.frame.width-(numberOfCellsInRow+1)*10)/numberOfCellsInRow
        print(width)
        let height = width + 30
        print(height)
        return CGSize(width: width, height: height)
    }
    //For margins of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    //For spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    //For spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        //imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    //To select and display image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedPhoto = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        selectedImage = selectedPhoto
        //self.dismiss(animated: true, completion: nil)
        dict = [
            "Name" : "",
            "Image": selectedImage
            ]
        nameAndImageArray.append(dict)
        filteredArray = nameAndImageArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
//        picker.dismiss(animated: true) {
//            self.showAlert("Enter name")
//        }
    }
    func showAlert(_ titleMessage: String) {
        let alert = UIAlertController(title: titleMessage, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.nameAndImageArray[self.selectedCellIndexPath]["Name"] = textField.text!
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
    @IBAction func sortClicked(_ sender: UIButton) {
        sortButton.isSelected.toggle()
        if sortButton.isSelected {
            sortButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            filteredArray = applySearchAndSort()
        }else if !sortButton.isSelected {
            filteredArray = nameAndImageArray
        }
        collectionView.reloadData()
    }
    func applySearchAndSort() -> [[String: Any]] {
        let tempData = nameAndImageArray.filter{(($0["Name"] as! String).lowercased()).starts(with: searchString.lowercased())}
        var sortedArray = [[String: Any]]()
        sortedArray = tempData.sorted(by: {($0["Name"] as! String) < ($1["Name"] as! String)})
        return sortedArray
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            searchString = searchText
            filteredArray = applySearchAndSort()
        }
        if searchText.count == 0 {
            filteredArray = nameAndImageArray
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        collectionView.reloadData()
    }
}
