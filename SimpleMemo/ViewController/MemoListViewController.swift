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
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    private var savedData = [MemoData]()
    private let refreshControl = UIRefreshControl()
    var selectedID: String?
    var selectedTitle: String?
    var selectedMemo: String?
    var deleteModeFlg = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(MemoListViewController.refresh(sender:)), for: .valueChanged)

        tableView.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }

        deleteButton.isEnabled = false

        prepareData()

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Theme")
    }

    override func viewWillDisappear(_ animated: Bool) {
        selectedID = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController" {
            let memoEditVC = (segue.destination as? MemoEditViewController)!
            if let id = selectedID {
                memoEditVC.id = id
            }
            memoEditVC.delegate = self

            tableView.setEditing(false, animated: true)
            deleteModeFlg = true
            if #available(iOS 13.0, *) {
                deleteButton.tintColor = .label
            } else {
                deleteButton.tintColor = .black
            }
        }
    }

    @IBAction func closeEditor(segue: UIStoryboardSegue) {
    }

    @IBAction func onClickDelete(_ sender: Any) {
        if deleteModeFlg == true {
            tableView.setEditing(true, animated: true)
            deleteModeFlg = false
            deleteButton.tintColor = .red
        } else {
            tableView.setEditing(false, animated: true)
            deleteModeFlg = true
            if #available(iOS 13.0, *) {
                deleteButton.tintColor = .label
            } else {
                deleteButton.tintColor = .black
            }
        }
    }

    @objc func refresh(sender: UIRefreshControl) {
        prepareData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    private func prepareData() {
        if let savedData = MemoDao.getMemo(MemoDao.MEMO_DATA) {
            self.savedData = Array(savedData.values).sorted {
                if let date1 = $0.date, let date2 = $1.date {
                    return date1 > date2
                }
                return true
            }
            if !self.savedData.isEmpty {
                deleteButton.isEnabled = true
            }
        }
    }

}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = savedData[indexPath.row].id
        selectedTitle = savedData[indexPath.row].title
        selectedMemo = savedData[indexPath.row].content
        if selectedID != nil && selectedMemo != nil && selectedTitle != nil {
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
        memoCell.updateDate.text = savedData[indexPath.row].date

        return memoCell
    }

    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            savedData.remove(at: indexPath.row)

            let group = Dictionary(grouping: savedData) { $0.id }
            var saveData = Dictionary<String?, MemoData>()

            for (key, value) in group {
                saveData[key] = value[0]
            }
            MemoDao.saveMemo(saveData)

            if savedData.isEmpty {
                tableView.setEditing(false, animated: true)
                deleteModeFlg = true
                if #available(iOS 13.0, *) {
                    deleteButton.tintColor = .label
                } else {
                    deleteButton.tintColor = .black
                }
                deleteButton.isEnabled = false
            }

            self.tableView.reloadData()
        }
    }

}

extension MemoListViewController: SavedDelegate {
    func saved() {
        prepareData()
        tableView.reloadData()

        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.makeToast("Saved!!", duration: 1, position: ToastPosition.center, style: style)
    }
}
