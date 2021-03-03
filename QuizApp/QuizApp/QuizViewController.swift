//
//  QuizViewController.swift
//  QuizApp
//
//  Created by 日置竜輔 on 2021/03/03.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var QuizNumberLabel: UILabel!
    @IBOutlet weak var QuizTextView: UITextView!
    @IBOutlet weak var AnswerButton1: UIButton!
    @IBOutlet weak var AnswerButton2: UIButton!
    @IBOutlet weak var AnswerButton3: UIButton!
    @IBOutlet weak var AnswerButton4: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        csvArray = loadCSV(fileName: "quiz")
        print(csvArray)
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        
        QuizNumberLabel.text = "第\(quizCount + 1)問"
        QuizTextView.text = quizArray[0]
        AnswerButton1.setTitle(quizArray[2], for: .normal)
        AnswerButton2.setTitle(quizArray[3], for: .normal)
        AnswerButton3.setTitle(quizArray[4], for: .normal)
        AnswerButton4.setTitle(quizArray[5], for: .normal)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
    @IBAction func btnAction(sender: UIButton){
        if sender.tag == Int(quizArray[1]){
            print("正解")
            correctCount += 1
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        print("スコア：\(correctCount)")
        AnswerButton1.isEnabled = false
        AnswerButton2.isEnabled = false
        AnswerButton3.isEnabled = false
        AnswerButton4.isEnabled = false
        judgeImageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.judgeImageView.isHidden = true
            self.nextQuiz()
            self.AnswerButton1.isEnabled = true
            self.AnswerButton2.isEnabled = true
            self.AnswerButton3.isEnabled = true
            self.AnswerButton4.isEnabled = true
        }
 
    }
    
    func nextQuiz(){
        quizCount += 1
        
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            QuizNumberLabel.text = "第\(quizCount + 1)問"
            QuizTextView.text = quizArray[0]
            AnswerButton1.setTitle(quizArray[2], for: .normal)
            AnswerButton2.setTitle(quizArray[3], for: .normal)
            AnswerButton3.setTitle(quizArray[4], for: .normal)
            AnswerButton4.setTitle(quizArray[5], for: .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
        


    }
    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        }catch{
            print("エラー")
        }
        return csvArray
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
