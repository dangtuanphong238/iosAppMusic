//
//  PlayerViewController.swift
//  Project_AppMusic
//
//  Created by Zalora on 6/22/20.
//  Copyright © 2020 Dang Phong. All rights reserved.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    
    //MARK:PROPERTIES**
    @IBOutlet var holder:UIView! // màn hình 3
    public var pos:Int = 0 // vị trí
    public var songs:[Song] = [] // một array các bài hát kiểu Struct Song
    var player : AVAudioPlayer? //Sử dụng lớp này để phát lại âm thanh
    @IBOutlet var sliderTimeSong:UISlider!
    //var progessTimeSong:UIProgressView!
    let playPauseButton = UIButton()
    let nextButton = UIButton()
    let preButton = UIButton()
    
    
    //MARK: CONSTRUCTOR UI**
    private let albumImageView:UIImageView = { //hàm này sử dụng để tạo và scale kich thước cho ảnh
        let imageView = UIImageView() //khởi tạo 1 đối tượng UIImageView
        imageView.contentMode = .scaleAspectFill // scale ảnh cho vừa vặn
        return imageView
    }()
    private let songNameLabel:UILabel = { //hàm này sử dụng để khởi tạo tên bài hát
        let label = UILabel()
        label.textAlignment = .center //căn chỉnh giữa
        label.numberOfLines = 0 // số dòng
        return label
    }()
    private let artistNameLabel:UILabel = { // hàm này sử dụng để khởi tạo tên nghệ sĩ
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let albumNameLabel:UILabel = { //hàm này sử dụng để khởi tạo tên album
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let timeStartLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let timeEndLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: OVERRIDE METHOD**
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() { //Đây là nơi mà ta sẽ setup layout lại cho subviews, trước khi nó xuất hiện trên màn hình
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0{
            configure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {// được gọi khi bắt đầu chuyển sang view khác.
        super.viewWillDisappear(animated)
        if let player = player{ //nếu đang phát nhạc
            player.stop()
        }
    }
    
    //MARK: CONFIGURE **
    func configure () {
        // setup player
        let song = songs[pos] // lấy ra bài hát ở array vị trí pos
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3") // mở tệp có tên + định dạng
        
        do{
            guard let urlString = urlString else { //nếu urlString giống nhau:
                return
            }
            //ngược lại:
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {// nếu player giống nhau:
                return //để yên và không làm gì
            }
            //ngược lại
            player.volume = 0.5
            player.play() // play bài mới
        }
        catch{
            print("error occurred")
        }
        
        //MARK: Set Khung
        //set khung ảnh cho album
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width - 45,
                                      height: holder.frame.size.width - 45)
        albumImageView.image = UIImage(named: song.imageName) // gán image từ name
        holder.addSubview(albumImageView) // add vào màn hình Activity 3

        //label : songname, artistname, album
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 60,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 120,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        timeStartLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 140,
                                      width: holder.frame.size.width - 20,
        
                                      height: 70)
        timeEndLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 140,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        songNameLabel.text = song.name //getText from name
        albumNameLabel.text = song.albumName //getText from name
        artistNameLabel.text = song.artistName //getText from name
        timeStartLabel.text = "00:00"
        timeEndLabel.text = "00:00"
        //add vào activity 3
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        holder.addSubview(timeStartLabel)
        holder.addSubview(timeEndLabel)
        //progessView timeSong
//        progessTimeSong = UIProgressView(frame: CGRect(x: 10,
//                                                 y: albumImageView.frame.size.height + 10 + 160, //chỉnh khoảng cách giữa các subview
//                                                 width: holder.frame.size.width - 20,
//                                                 height: 70))
//        holder.addSubview(progessTimeSong)
//        progessTimeSong.progress = 10
        //slider time nhạc
        sliderTimeSong = UISlider(frame: CGRect(x: 10,
                                         y: albumImageView.frame.size.height + 10 + 160, //chỉnh khoảng cách giữa các subview
                                         width: holder.frame.size.width - 20,
                                         height: 70))
       
        sliderTimeSong.addTarget(self, action: #selector(changeSliderValueFollowPlayerCurrentTime), for: .valueChanged)
        holder.addSubview(sliderTimeSong)
        
        
        //frame : điều chỉnh kích thước cho các button next, pre, play
        let yPosition = artistNameLabel.frame.origin.y + 70 + 40
        let size : CGFloat = 60
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        
        nextButton.frame = CGRect(x: (holder.frame.size.width - size) - 20,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        preButton .frame = CGRect(x: 20,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        //MARK: Actions button
        
        //add sự kiện touchUpInside cho các button
        playPauseButton.addTarget(self, action: #selector(tapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        preButton.addTarget(self, action: #selector(tapPreButton), for: .touchUpInside)
        
        //gán images cho button lấy từ thư viện
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        preButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        //gán màu
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        preButton.tintColor = .black

        //add vào Activity 3
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(preButton)
        
        //slider tăng giảm âm
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height - 60,
                                            width: holder.frame.size.width - 40,
                                            height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)

    }
    
    //MARK: OBJC FUNC ACTIONS**
    //action next
    @objc func tapNextButton()
    {
        if pos < (songs.count - 1)
           {
               pos = pos + 1;
               player?.stop()
               for subview in holder.subviews{
                   subview.removeFromSuperview()
               }
               configure()
           }
    }
    
    //action pre
    @objc func tapPreButton()
    {
        if pos > 0
        {
            pos = pos - 1;
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    //action play_pause
    @objc func tapPlayPauseButton()
    {
        if player?.isPlaying == true{
            //pause
            player?.pause()
            //show play button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)

        }
        else{
            //play
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    //action tăng giảm âm
    @objc func didSlideSlider(_ slider:UISlider)
    {
        let value = slider.value
        player?.volume = value
    }
    
    //action time chạy theo nhạc
    @objc func changeSliderValueFollowPlayerCurrentTime()
    {
        if player?.isPlaying == true{
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
        }
    }
    @objc func updateTime(_ timer: Timer) {
        //time start
        let currentTime = player?.currentTime
        sliderTimeSong.value = Float(currentTime!)
        var elapsedTime: TimeInterval = currentTime!
        var minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        var seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        var strMinutes = String(format: "%02d", minutes)
        var strSeconds = String(format: "%02d", seconds)
        timeStartLabel.text = "\(strMinutes):\(strSeconds)"
        sliderTimeSong.maximumValue = Float(player!.duration)

        //tổng time song
        let totalTime = player?.duration
        sliderTimeSong.value = Float(totalTime!)
        elapsedTime = totalTime!
        minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        strMinutes = String(format: "%02d", minutes)
        strSeconds = String(format: "%02d", seconds)
        timeEndLabel.text = "\(strMinutes):\(strSeconds)"
        
        self.sliderTimeSong.value = Float(self.player!.currentTime)
    }

}

