//
//  ViewController.swift
//  currencyAPI
//
//  Created by Daniel Kouba on 2/24/17.
//  Copyright © 2017 Daniel Kouba. All rights reserved.
//

import UIKit
import Alamofire


class ConversionTableViewController: UITableViewController {

    var basedata: NSDictionary?
    var currencyContainer: Array<Currency> = [Currency]()
    var delegate: conversionDelegate?
    var lookup: String?
    var currentCalc: CalcSettings?
    
    @IBOutlet weak var navBar: UINavigationBar!

    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////////////////////////////////////
        // Perform API request

        let url = "http://api.fixer.io/latest?base=" + self.lookup!
        Alamofire.request(url, method: .get , parameters: nil, headers: nil)
            .responseJSON{ response in
                
                ////////////////////////////////////////
                // Perform actions on response
                if let jsonResult = response.result.value as? NSDictionary {
                    ////////////////////////////////////////
                    // Get rates from returned data
                    for (key, value) in jsonResult {
                        if String(describing: key) == "rates" {
                            self.basedata = value as? NSDictionary;
                        }
                    }
                    ////////////////////////////////////////
                    // Create Currency Objects and Store in Array
                    for (key, value) in self.basedata! {
                        self.currencyContainer.append( Currency(name: key as! String, rate: value as! Double))
                    }
                    ////////////////////////////////////////
                    // Refresh Table Data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
        // END API Request
        ////////////////////////////////////////
        
        ////////////////////////////////////////
        // Create Nav Bar title
        let titleView = UIView()
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        let label = UILabel();
        label.frame = CGRect(x: 50, y: 0, width: 50, height: 40)
        let imageView = UIImageView()
        
        if self.lookup == self.currentCalc?.base {
            label.text = self.currentCalc?.second;
            imageView.image = UIImage(named: self.currentCalc!.second)
        } else if self.lookup == currentCalc?.second {
            label.text = self.currentCalc?.base;
            imageView.image = UIImage(named: self.currentCalc!.base)
        }
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.clear
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        imageView.frame = CGRect(x:0,y: 0,width: 40,height: 40)
        imageView.contentMode = .scaleAspectFill
        titleView.addSubview(button)
        titleView.backgroundColor = UIColor.clear
        titleView.addSubview(label)
        titleView.backgroundColor = UIColor.clear
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
    }
    // END View Did Load
    ////////////////////////////////////////
    
    
    ////////////////////////////////////////
    // Click on title to go back
    func clickOnButton() {
         delegate?.cancelButtonPressedFrom(controller: self)
    }
    

    ////////////////////////////////////////
    // Return number of cells to create
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyContainer.count
    }

    ////////////////////////////////////////
    // Create Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ////////////////////////////////////////
        // Load Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as! CustomCurrencyCell
        // Apply Data to cell
        cell.model = currencyContainer[indexPath.row]
        return cell
    }
    
    ////////////////////////////////////////
    // Handle table cell press
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.lookup == self.currentCalc?.base {
            currentCalc?.rate = self.currencyContainer[indexPath.row].rate
            currentCalc?.second = self.currencyContainer[indexPath.row].name
        } else if self.lookup == currentCalc?.second {
            currentCalc?.rate = 1 / self.currencyContainer[indexPath.row].rate
            currentCalc?.base = self.currencyContainer[indexPath.row].name
        }
        
        delegate?.conversionTableViewController(controller: self, userSelectedBase: self.currentCalc!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

