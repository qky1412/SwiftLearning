//
//  MusicPlayerViewController.swift
//  SwiftLearning
//
//  Created by qky on 16/11/1.
//  Copyright © 2016年 boostfield. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var sliderTime: UISlider!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelTotalTime: UILabel!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mPageControl: UIPageControl!
    
    let cellId = "trackCell"
    
    var player:AVPlayer!
    var updater : CADisplayLink! = nil
    var tracks = [Track(title: "将军令", mediaUrl: "http://hifimedia.oss-cn-hangzhou.aliyuncs.com/%E5%90%B4%E5%85%8B%E7%BE%A3%20-%20%E5%B0%86%E5%86%9B%E4%BB%A4.mp3"), Track(title: "宝贝", mediaUrl: "http://hifimedia.oss-cn-hangzhou.aliyuncs.com/web/tunes/%E8%8E%AB%E6%96%87%E8%94%9A%20-%20%E5%AE%9D%E8%B4%9D.mp3")]
    var currentTrackIndex = 0
    
    var lpView: LPView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        btnPlay.setTitle("Play", for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initViews() {
        navigationController?.navigationBar.tintColor = UIColor.appPrimaryColor()
        navigationController?.navigationBar.barTintColor = UIColor.appBlackColor()
        view.backgroundColor = UIColor.appBlackColor()
        mScrollView.contentSize = CGSize(width: 2 * self.view.bounds.size.width, height: mScrollView.bounds.size.height)
        mScrollView.delegate = self
        let size = mScrollView.bounds.size
        let pageList = UIView()
        //pageList.backgroundColor = UIColor.green
        pageList.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let trackListTableView = UITableView(frame: pageList.frame, style: .plain)
        trackListTableView.backgroundColor = UIColor.clear
        trackListTableView.delegate = self
        trackListTableView.dataSource = self
        trackListTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        trackListTableView.tableFooterView = UIView()
        pageList.addSubview(trackListTableView)
        mScrollView.addSubview(pageList)
        if tracks.count == 0 {
            btnNext.isEnabled = false
            btnPlay.isEnabled = false
            btnNext.isEnabled = false
        }
        
        let pageLP = UIView()
        //pageLP.backgroundColor = UIColor.black
        pageLP.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
        lpView = Bundle.main.loadNibNamed("LPView", owner: self, options: nil)?.first as? LPView
        lpView?.backgroundColor = UIColor.clear
        lpView?.frame = CGRect(x: 0, y: 0, width: pageLP.frame.width, height: pageLP.frame.height)
        pageLP.addSubview(lpView!)
        
        mScrollView.addSubview(pageLP)
        
        mPageControl.numberOfPages = 2
        mPageControl.currentPage = 0
        mPageControl.addTarget(self, action: #selector(MusicPlayerViewController.pageControlChanged(sender:)), for: .valueChanged)
    }
    
    func initData() {
        let url = NSURL(string: tracks[currentTrackIndex].mediaUrl)
        let playerItem = AVPlayerItem(url: url as! URL)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer=AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.view.layer.addSublayer(playerLayer)
        
        sliderTime.minimumValue = 0
        sliderTime.isContinuous = false
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player.currentTime())
                self.sliderTime.value = Float ( time )
                
                let mins  = Int(time/60.0)
                let secs = Int(fmodf(Float(time), 60.0))
                let minsString = mins < 10 ? String(format: "0%d", mins) : String(format: "%d", mins)
                let secsString = secs < 10 ? String(format: "0%d", secs) : String(format: "%d", secs)
                self.labelCurrentTime.text = String(format: "%@:%@", minsString, secsString)
            }
        }
        changeTrack(track: tracks[currentTrackIndex])
    }
    
    func changeTrack(track: Track) {
        let url = NSURL(string: track.mediaUrl)
        let playerItem = AVPlayerItem(url: url as! URL)
        player.replaceCurrentItem(with: playerItem)
        let totalTime = Float(CMTimeGetSeconds(playerItem.asset.duration))
        sliderTime.maximumValue = totalTime
        let totalMins  = Int(totalTime / 60.0)
        let totalSecs = Int(fmodf(totalTime, 60.0))
        let totalMinsString = totalMins < 10 ? String(format: "0%d", totalMins) : String(format: "%d", totalMins)
        let totalSecsString = totalSecs < 10 ? String(format: "0%d", totalSecs) : String(format: "%d", totalSecs)
        self.labelTotalTime.text = String(format: "%@:%@", totalMinsString, totalSecsString)
        player.play()
        btnPlay.setTitle("Pause", for: .normal)
        lpView?.rotate360Degrees(duration: 33.3, completionDelegate: nil)
    }
    
    func pageControlChanged(sender: UIPageControl) {
        var frame = mScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        mScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    @IBAction func toggleMusic(_ sender: Any) {
        if player.rate == 1 {
            player.pause()
            btnPlay.setTitle("Play", for: .normal)
            lpView?.pauseAnimation()
        } else {
            player.play()
            btnPlay.setTitle("Pause", for: .normal)
            lpView?.resumeAnimation()
        }
    }

    @IBAction func sliderChange(_ sender: Any) {
        let seconds : Int64 = Int64(sliderTime.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
            btnPlay.setTitle("Pause", for: .normal)
        }
    }
    @IBAction func nextTrack(_ sender: Any) {
        let trackCount = tracks.count
        currentTrackIndex += 1
        if currentTrackIndex  == trackCount {
            currentTrackIndex = 0
        }
        changeTrack(track: tracks[currentTrackIndex])
    }
    @IBAction func prevTrack(_ sender: Any) {
        currentTrackIndex -= 1
        if currentTrackIndex == -1 {
            currentTrackIndex = 0
        }
        
        changeTrack(track: tracks[currentTrackIndex])
        
    }
}
extension MusicPlayerViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(mScrollView.contentOffset.x / mScrollView.frame.size.width)
        mPageControl.currentPage = page
    }
}

extension MusicPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)! as UITableViewCell
        cell.textLabel?.text = tracks[indexPath.row].title
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
