//
//  FuelPricesViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit

class PricesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var collectionView: UICollectionView!

    var messageHelper = MessageHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.superViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.prepareCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Collection View Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == pageControl {

            let inset = (self.pageControl.bounds.width - self.pageControl.size(forNumberOfPages: self.pageControl.numberOfPages).width)/2
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        return .zero
    }

    // MARK: ScrollView Delegate Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
