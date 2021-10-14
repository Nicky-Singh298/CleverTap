//
//  ViewController.swift
//  CleverTapDemo
//
//  Created by Nicky on 12/10/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previoustButton: UIButton!

    //MARK:- Properties
    var dogImagesArray = DogImageModel(){
        didSet{
            setButtonsStatus()
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }
    
    var subImageArray = [String]()
    var buttonTapped = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.frame.size.height = 508 * screenHeightfactor
        previoustButton.isEnabled = false
        apiCall()
    }
    
    func apiCall(){
        
        if !StaticHelper.shared.isInternetConnected{
            StaticHelper.showAlert(message: "", title: internetError, VC: self)
            return
        }
        
        if let url = URL(string: jsonUrl) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    
                     let res = try JSONDecoder().decode(DogImageModel.self, from: data)
                    
                    self.dogImagesArray = res
                   
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = 10
        previoustButton.layer.cornerRadius = 10
        
    }

    //-------------------------------------------------------
    //MARK:- collection view delegate method
    //-------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dogImagesArray.message?.count ?? 0
      
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: imageCollectionView.frame.size.width, height: 320 * screenHeightfactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImgCollectionViewCell", for: indexPath) as! DogImgCollectionViewCell
 
        var dict = String()
  
        if buttonTapped == 0{
            dict = subImageArray[indexPath.row]
            subImageArray.remove(at: subImageArray.count - 1)
        }
        else if buttonTapped == 1{
            dict = (dogImagesArray.message?.randomElement())!
            subImageArray.append(dict)
            
        }else{
            dict = (dogImagesArray.message?[0])!
        }
        
        
        if let images = StaticHelper.shared.getImage(from: dict){
            cell.dogImageView.image = images
        }
          
        return cell
        
    }
    
    //MARK:- ACtion Methods
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        buttonTapped = 1
        previoustButton.isEnabled = true
        imageCollectionView.reloadData()
    }
    @IBAction func previousButtonClicked(_ sender: UIButton) {
        buttonTapped = 0
        if subImageArray.count <= 1{
            previoustButton.isEnabled = false
        }else{
            previoustButton.isEnabled = true
        }
        imageCollectionView.reloadData()
        
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let scrollSize = self.imageCollectionView.contentOffset.x
//        nextButton.isEnabled = true
//        if scrollSize == 0.0 {
//            nextButton.isEnabled = false
//        }
//        else{
//            nextButton.isEnabled = true
//        }
//    }

    func setButtonsStatus(){
        DispatchQueue.main.async {
            if (self.dogImagesArray.message?.count ?? 0) > 1{
                self.nextButton.isEnabled = true
            }
            else{
                self.nextButton.isEnabled = false
            }
        }
    }
    
}
