import Foundation
import UIKit
import SwiftyUserDefaults

class OrdersViewController: UIViewController {
    @IBOutlet var tableView: UITableView?
    @IBOutlet var ordersHeaderLabel: UILabel! {didSet{ordersHeaderLabel.localized()}}
    
    var ordersTimer: Timer?
    
    var orders: [Order]? {
        didSet {
            let tabBarItem = self.tabBarController?.tabBar.items?[1]
            if let orders = orders {
                let filteredOrdersCount = orders.filter({ (order) -> Bool in
                    if let sessionId = order.sessionId {
                        return !Defaults[.visitedOrders].contains(sessionId)
                    }
                    return false
                }).count
                
                if filteredOrdersCount == 0 {
                    tabBarItem?.badgeValue = nil
                } else {
                    tabBarItem?.badgeValue = String(filteredOrdersCount)
                }
            } else {
                tabBarItem?.badgeValue = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationController?.tabBarItem.title = "tabOrders".localized()

        ordersTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(OrdersViewController.fireOrdersTimer), userInfo: nil, repeats: true)
        ordersTimer?.fire()
    }
    
    @objc fileprivate func fireOrdersTimer() {
        if let monitoredSessionId = Defaults[.monitoredSessionId] {
            OrdersDownloader.get(orderId: monitoredSessionId, order: { (order) in
                if let sessionId = order.sessionId {
                    Defaults[.monitoredSessionId] = nil
                    
                    if Defaults[.confirmedSessionIds] == nil {
                        Defaults[.confirmedSessionIds] = [:]
                    }
                    
                    Defaults[.confirmedSessionIds]?[sessionId] = Date()
                }

                self.refreshData()
            }, fail: {
                print("fail")
            })
        }
        
        if orders == nil, let confirmedSessionIds = Defaults[.confirmedSessionIds], !confirmedSessionIds.isEmpty {
            refreshData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.estimatedRowHeight = 44
        tableView?.rowHeight = UITableViewAutomaticDimension
        if let ordersHeader = UINib(nibName: "OrdersHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as? OrdersHeader {
            tableView?.tableHeaderView = ordersHeader
        }
        navigationItem.titleView = UIImageView(image: UIImage(named: "LogoText"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        removePast24HOrders()
        refreshData()
        checkVisitedOrders()
    }
    
    fileprivate func refreshData() {
        if let email = Defaults[.email], let sessions = Defaults[.confirmedSessionIds]?.keys {
            OrdersDownloader.get(email: email, sessions: Array(sessions), orders: { (orders) in
                if !orders.isEmpty {
                    self.orders = orders
                    self.tableView?.reloadData()
                } else {
                    self.orders = nil
                    self.tableView?.reloadData()
                }
            }) {
                self.orders = nil
                self.tableView?.reloadData()
                print("fail?")
            }
        }
    }
    
    fileprivate func checkVisitedOrders() {
        if let orders = orders {
            orders.forEach({ (order) in
                if let sessionId = order.sessionId {
                    if !Defaults[.visitedOrders].contains(sessionId) {
                        Defaults[.visitedOrders].append(sessionId)
                    }
                }
            })
            
            self.orders = orders //just to refresh didSet
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.sizeHeaderToFit()
    }
    
    fileprivate func removePast24HOrders() {
        if let confirmedSessionIds = Defaults[.confirmedSessionIds] as? [String: Date] {
            confirmedSessionIds.filter({
                let timeInterval = Date().timeIntervalSince($1)
                return timeInterval > 60*60*24
            }).forEach{
                _ = Defaults[.confirmedSessionIds]?.removeValue(forKey: $0.key)
            }
        }
    }
}

extension OrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let orders = self.orders, !orders.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
                cell.configure(order: orders[indexPath.row])
                return cell
            }
            
            
        }

        return tableView.dequeueReusableCell(withIdentifier: "OrdersNoDataCell", for: indexPath)
    }
}

extension OrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
