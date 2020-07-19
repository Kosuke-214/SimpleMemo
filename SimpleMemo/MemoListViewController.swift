//
//  ViewController.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/18.
//  Copyright © 2020 shibata. All rights reserved.
//

import UIKit
import Toast_Swift

class MemoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var savedData = [MemoData]()
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

        savedData = MemoDao.getMemo("MemoData")!
        tableView.reloadData()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController" {
            let memoEditVC = (segue.destination as? MemoEditViewController)!
            if let title = selectedTitle {
                memoEditVC.titleText = title
            }
            memoEditVC.presentationController?.delegate = self
        }
    }

    @IBAction func closeEditor(segue: UIStoryboardSegue) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.makeToast("Saved!!", duration: 1, position: ToastPosition.center, style: style)
    }

}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = savedData[indexPath.row].title
        selectedMemo = savedData[indexPath.row].content
        if selectedMemo != nil && selectedTitle != nil {
            performSegue(withIdentifier: "toEditViewController", sender: nil)
        }

    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }

        memoCell.memoTitle.text = savedData[indexPath.row].title

        return memoCell
    }


}

@available(iOS 13.0, *)
extension MemoListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.makeToast("Saved!!", duration: 1, position: ToastPosition.center, style: style)
    }
}
