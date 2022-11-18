import Foundation
import UIKit

class OffersViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var header: OffersSearchHeader? = {
        let searchHeader = UINib(nibName: "OffersSearchHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? OffersSearchHeader
        searchHeader?.delegate = self
        return searchHeader
    }()
    
    var offers: [Offer]?
    var count: Int?
    var headerHeight: CGFloat = 210
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationController?.tabBarItem.title = "tabOffers".localized()
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        refreshControl.addTarget(self, action: #selector(OffersViewController.fireSearch), for: .valueChanged)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "LogoText"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
        
        header?.fireSearch()
    }
    
    func fireSearch() {
        header?.fireSearch()
    }
    
    func refreshData(query: String?, params: OffersParameters?) {
        header?.activityIndicator.startAnimating()
        OffersDownloader.get(query: query, params: params, pagination: nil, offers: { (offers, count) in
            self.offers = offers
            self.count = count
            
            self.header?.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
            if let count = count, count != 0, offers.count < count {
                self.downloadRestOfOffers(pagination: Pagination(limit: count - offers.count, offset: offers.count), query: query, params: params)
            }
        }) {
            self.offers = nil
            self.count = nil
            
            self.refreshControl.endRefreshing()
            self.header?.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func downloadRestOfOffers(pagination: Pagination, query: String?, params: OffersParameters?) {
        OffersDownloader.get(query: query, params: params, pagination: pagination, offers: { (offers, _) in
            self.offers?.append(contentsOf: offers)
            
            self.tableView.reloadData()
        }) { 
            print("fail?")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OfferViewControler,
            let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            destination.offer = offers?[selectedRowIndexPath.row]
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension OffersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let offersCount = offers?.count,
            offersCount > 0 {
            return offersCount
        }
        return 1 // NoDataCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let offers = offers, !offers.isEmpty,
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath) as? OfferCell {
            cell.configureCell(offer: offers[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferNoDataCell", for: indexPath) as! OfferNoDataCell
        cell.emptyResults = offers == nil ? true : !offers!.isEmpty
        return cell
    }
}

extension OffersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
}

extension OffersViewController: OffersSearchHeaderDelegate {
    func searchHeaderDidSearch(query: String?, params: OffersParameters?) {
        view.endEditing(true)
        refreshData(query: query, params: params)
    }
    
    func searchHeaderHeightChange(size: HeaderHeight) {
        tableView.beginUpdates()
        headerHeight = size == .shrunk ? 210 : 330
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.3) {
            self.header?.layoutIfNeeded()
        }
    }
}
