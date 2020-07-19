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
    var titleText: String?
    var memo: String?
    var index: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }

        MemoDao.getMemo("MemoData")?.forEach { data in
            if data.title == titleText {
                titleHeader.title = data.title
                memoTitle.text = data.title
                memoText.text = data.content
            }

        }
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
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        if let saveTitle = memoTitle.text,
            let saveMemo = memoText.text {

            if var savedData: [MemoData] = MemoDao.getMemo("MemoData") {
                savedData.append(MemoData(title: saveTitle, content: saveMemo))
                MemoDao.saveMemo(savedData)
            }

        }
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.makeToast("Saved!!", duration: 1, position: ToastPosition.center, style: style)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
