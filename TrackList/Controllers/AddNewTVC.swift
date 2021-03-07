//
//  AddNewTVC.swift
//  TrackList
//
//  Created by Евгений on 20.12.2020.
//

import UIKit

class AddNewTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelResult: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var currentTrackList: TrackList?
    var imagesIsChange = false
    let searchController = UISearchController(searchResultsController: nil)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationItem.searchController = searchController
        updateChangeText()

    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagesView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imagesView.contentMode = .scaleAspectFill
        imagesView.clipsToBounds = true
        imagesIsChange = true
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 3 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photolibraryIcon = #imageLiteral(resourceName: "folder")
            let fromNetworksIcon = #imageLiteral(resourceName: "Network")
            let ac = UIAlertController(title: "Выбери", message: "Действие", preferredStyle: .actionSheet)
            let fromNetwork = UIAlertAction(title: "Из интернета", style: .default, handler: { _ in
                let ac = UIAlertController(title: "Вставь ссылку из интернета", message: "URL", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                let download = UIAlertAction(title: "Загрузить", style: .default, handler: {_ in
                    let textField = ac.textFields?.first
                    self.fetchImage(string: (textField?.text)!)
                    self.imagesIsChange = true
                })
                ac.addTextField { (textField) in }
//                ac.addAction(ok)
                ac.addAction(download)
                self.present(ac, animated: true, completion: nil)
            })
            
            fromNetwork.setValue(fromNetworksIcon, forKey: "image")
            fromNetwork.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let camera = UIAlertAction(title: "Камера", style: .default, handler: {_ in
                self.chooseImagePicker(sourse: .camera)
            })
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photolibrary = UIAlertAction(title: "Галерея", style: .default, handler: {_ in
                self.chooseImagePicker(sourse: .photoLibrary)
            })
            photolibrary.setValue(photolibraryIcon, forKey: "image")
            photolibrary.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(camera) 
            ac.addAction(photolibrary)
            ac.addAction(fromNetwork)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)
        } else {
            view.endEditing(true)
        }
        
    }
    
    func fetchImage(string: String) {
        guard let url = URL(string: string) else { return }
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url) { (data, responce, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imagesView.image = image
                }
            }
        }
        .resume()
    }
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func updateChangeText() {
        let artistNameTextField =  textFields[0].text ?? ""
        let albumNameTextField = textFields[1].text ?? ""
        let songNameTextField = textFields[2].text ?? ""
        
        saveBarButtonItem.isEnabled = !artistNameTextField.isEmpty && !albumNameTextField.isEmpty && !songNameTextField.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateChangeText()
    }
    
    
    func saveTrackList() {
        
        let image = imagesIsChange ? imagesView.image : #imageLiteral(resourceName: "og__dcaiwstv206e_image")
        
        let cover = image!.pngData()
        let newTrackList = TrackList(artist: textFields[0].text!, album: textFields[1].text!, song: textFields[2].text!, cover: cover,data: dateLabelResult.text!,bio: textFields[3].text!,link: textFields[4].text!)
        if currentTrackList != nil {
            try! realm.write {
                currentTrackList?.artist = newTrackList.artist
                currentTrackList?.album = newTrackList.album
                currentTrackList?.song = newTrackList.song
                currentTrackList?.cover = newTrackList.cover
                currentTrackList?.data = newTrackList.data
                currentTrackList?.bio = newTrackList.bio
                currentTrackList?.link =  newTrackList.link
            }
        } else {
            StorageManager.saveObject(newTrackList)
        }
    }
    
    
    @IBAction func changeDateToDateResult(_ sender: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.locale = Locale.init(identifier: "ru_Ru")
        let dateValue = dateFormat.string(from: sender.date)
        dateLabelResult.text = dateValue
    }
}

extension AddNewTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
