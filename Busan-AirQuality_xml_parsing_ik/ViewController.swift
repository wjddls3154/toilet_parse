//
//  ViewController.swift
//  Busan-AirQuality_xml_parsing_ik
//
//  Created by D7702_10 on 2018. 10. 15..
//  Copyright © 2018년 jik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    var items = [PublicToiletData]()
    var item = PublicToiletData()
    var myInstName = ""
    var myToiletName = ""
    var myType = ""
    var currentElement = ""
    var currentTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTable.delegate = self
        myTable.dataSource = self
        myParse()
        
        
    }
    
    @objc func myParse() {
        let skey = "dH7oyxOq53N%2B%2FRde8Bv2BfStdElt4%2BYo8Y2uv0qcVTAEE2JZi3fsxzkkncorSPsCWBb%2Fp4m4l2T6c80hxRzbrA%3D%3D"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/PublicToilet/getToiletInfoList?ServiceKey=\(skey)&numOfRows=100"
        
        if URL(string: strURL) != nil {
            
            if let myParser = XMLParser(contentsOf: URL(string: strURL)!) {
                myParser.delegate = self
                
                if myParser.parse(){
                    print("파싱 성공")
                    for i in 0..<items.count {
                        
                        
                        
                        print("\(items[i].tInstName) : \(items[i].tToiletName)  \(items[i].tType)")
                    }
                } else {
                    print("파싱 실패")
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        let instname = cell.viewWithTag(3) as! UILabel
        let toiletname = cell.viewWithTag(2) as! UILabel
        let type = cell.viewWithTag(1) as! UILabel
        
        instname.text = items[indexPath.row].tInstName
        toiletname.text = items[indexPath.row].tToiletName
        type.text = items[indexPath.row].tType
        
        return cell
    }
    
    // XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElement {
            case "instName" : myInstName = data
            case "toiletName" : myToiletName = data
            case "type" : myType = data
            default : break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = PublicToiletData()
            myItem.tInstName = myInstName
            myItem.tToiletName = myToiletName
            myItem.tType = myType
            items.append(myItem)
        }
    }
}
