//
//  MemoEditViewController.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/18.
//  Copyright © 2020 shibata. All rights reserved.
//

import UIKit
import Toast_Swift

class MemoEditViewController: UIViewController {

    @IBOutlet weak var titleHeader: UINavigationItem!
    @IBOutlet weak var memoTitle: UITextField!
    @IBOutlet weak var memoText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var id: String?
    var titleText: String?
    var memo: String?
    private var isNeedSaveFlg = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }

        if let savedData = MemoDao.getMemo(MemoDao.MEMO_DATA) {
            Array(savedData.values).forEach { data in
                if data.id == id {
                    titleHeader.title = data.title
                    memoTitle.text = data.title
                    memoText.text = data.content
                }
            }
        }

        memoTitle.delegate = self
        memoText.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }

        if isNeedSaveFlg {
            saveMemoData()
        }
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        saveMemoData()
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.makeToast("Saved!!", duration: 1, position: ToastPosition.center, style: style)
    }

    private func saveMemoData() {
        if let saveTitle = memoTitle.text,
            let saveMemo = memoText.text {

            var saveData = Dictionary<String?, MemoData>()

            if var savedData = MemoDao.getMemo(MemoDao.MEMO_DATA){

                var savedFlg = false

                for (id, _) in savedData {
                    if id == self.id {
                        savedFlg = true
                        savedData[id]?.title = saveTitle
                        savedData[id]?.content = saveMemo
                        savedData[id]?.date = Util().nowDate()
                    }
                }

                if !savedFlg {
                    let id = Util().idGenerator()
                    savedData[id] = MemoData(id: id, title: saveTitle, content: saveMemo, date: Util().nowDate())
                }
                saveData = savedData
            }

            MemoDao.saveMemo(saveData)
            isNeedSaveFlg = false
        }
    }

}

extension MemoEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isNeedSaveFlg = true
        MemoDao.saveSavedFlg(true)
    }
}

extension MemoEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        isNeedSaveFlg = true
        MemoDao.saveSavedFlg(true)
        return true
    }

}
