//
//  PetrelBannerCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import FSPagerView

class PetrelBannerCell: UITableViewCell {

    fileprivate var videoURL = ""
    fileprivate var picsURl: [String] = []
    
    let picCellIdentifier = "pic"
    let videoCellIdentifier = "video"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(pageView)
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(videoURL: String, picsURLs: [String]) {
        self.videoURL = videoURL
        self.picsURl = picsURLs
        pageView.reloadData()
        pageControl.numberOfPages = numberOfItems(in: pageView)
    }
    
    
    override func layoutSubviews() {
        pageView.frame = bounds
        super.layoutSubviews()
    }

    lazy var pageControl: FSPageControl = {
        let p = FSPageControl(frame: .zero)
        return p
    }()
    
    lazy var pageView: FSPagerView = {
        let view = FSPagerView(frame: .zero)
        view.delegate = self
        view.dataSource = self
        view.register(PetrelPicCell.self, forCellWithReuseIdentifier: picCellIdentifier)
        view.register(PetrelVideoCell.self, forCellWithReuseIdentifier: videoCellIdentifier)
        view.automaticSlidingInterval = 3
        view.isInfinite = true
        
        return view
    }()
}


extension PetrelBannerCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if videoURL.isEmpty {
            pageView.automaticSlidingInterval = 3
            return picsURl.count
        } else {
            pageView.automaticSlidingInterval = 0
            return picsURl.count + 1
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        if let cell = cell as? PetrelVideoCell {
            cell.pause()
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if videoURL.isEmpty {
            let cell = pageView.dequeueReusableCell(withReuseIdentifier: picCellIdentifier, at: index) as! PetrelPicCell
            cell.contentImageView.setImage(picsURl[index])
            cell.contentImageView.setScopeImages(picsURl, index: index)
            return cell
        } else {
            if index == 0 {
                let cell = pagerView.dequeueReusableCell(withReuseIdentifier: videoCellIdentifier, at: index) as! PetrelVideoCell
                let firstImage = picsURl.count > 0 ? picsURl[0] : ""
                cell.render(videoURL, firstImage: firstImage)
                return cell
            } else {
                let cell = pageView.dequeueReusableCell(withReuseIdentifier: picCellIdentifier, at: index) as! PetrelPicCell
                cell.contentImageView.setImage(picsURl[index - 1])
                cell.contentImageView.setScopeImages(picsURl, index: index - 1)
                return cell
            }
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
    }

}
