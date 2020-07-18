//
//  ViewController.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/18.
//  Copyright © 2020 shibata. All rights reserved.
//

import UIKit

class MemoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let testData = ["a", "b", "c"]
    var selectedTitle: String?
    var selectedMemo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController" {
            let memoEditVC = (segue.destination as? MemoEditViewController)!
            if let selectedMemo = self.selectedMemo,
                let selectedTitle = self.selectedTitle {
                memoEditVC.titleText = selectedTitle
                memoEditVC.memo = selectedMemo
            }
        }
    }

    @IBAction func closeEditor(segue: UIStoryboardSegue) {
        
    }

}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = testData[indexPath.row]
        selectedMemo = "\(testData[indexPath.row])です"
        if selectedMemo != nil && selectedTitle != nil {
            performSegue(withIdentifier: "toEditViewController", sender: nil)
        }

    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }

        memoCell.memoTitle.text = testData[indexPath.row]

        return memoCell
    }


}
