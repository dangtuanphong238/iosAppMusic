//
//  ViewController.swift
//  Project_AppMusic
//
//  Created by Zalora on 6/22/20.
//  Copyright © 2020 Dang Phong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table:UITableView! //Activity 2
    var songs = [Song]() // khởi tạo 1 mảng nhạc
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSongs()
        //uỷ quyền
        table.delegate = self
        table.dataSource = self
    }
    
    func configureSongs() { // add song vào array
        
        songs.append(Song(name: "Gene",
                          albumName: "album binz",
                          artistName: "Binz",
                          imageName: "cover1",
                          trackName: "song1"))
        songs.append(Song(name: "Cao Oc 20",
                          albumName: "album bray",
                          artistName: "Bray",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Dau vay du roi",
                          albumName: "album karik",
                          artistName: "Karik",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "Gene",
                          albumName: "album binz",
                          artistName: "Binz",
                          imageName: "cover1",
                          trackName: "song1"))
        songs.append(Song(name: "Cao Oc 20",
                          albumName: "album bray",
                          artistName: "Bray",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Dau vay du roi",
                          albumName: "album karik",
                          artistName: "Karik",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "Gene",
                          albumName: "album binz",
                          artistName: "Binz",
                          imageName: "cover1",
                          trackName: "song1"))
        songs.append(Song(name: "Cao Oc 20",
                          albumName: "album bray",
                          artistName: "Bray",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Dau vay du roi",
                          albumName: "album karik",
                          artistName: "Karik",
                          imageName: "cover3",
                          trackName: "song3"))
    }
    
    //hàm trả về số lượng bài
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    //hàm trả về dòng trên table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        //configure
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let pos = indexPath.row
        //songs
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        
        vc.songs = songs
        vc.pos = pos
        
        present(vc, animated: true)
    }
    
}
struct Song {
    let name:String
    let albumName:String
    let artistName:String
    let imageName:String
    let trackName:String
}

