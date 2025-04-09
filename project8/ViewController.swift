//
//  ViewController.swift
//  project8
//
//  Created by Waterflow Technology on 08/04/2025.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0
    var level = 1
    
    //All three of those have the @objc attribute because they are going to be called by the buttons – by Objective-C code – when they are tapped.
    @objc func letterTapped(_ sender: UIButton) {
    }

    @objc func submitTapped(_ sender: UIButton) {
    }

    @objc func clearTapped(_ sender: UIButton) {
    }
    
    func loadLevel(){
        var clueString = "";
        var solutionString = "";
        var letterBits = [String]();
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL,encoding: .utf8) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    // enumerated method provided index along with the element in a tuple while iterating
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]

                        clueString += "\(index + 1). \(clue)\n"

                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        solutions.append(solutionWord)

                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
        
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //more code to add
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
       
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0 //0 - as many lines as the text requires
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField();
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false;
        currentAnswer.placeholder = "Tap letter to guess";
        currentAnswer.textAlignment = .center;
        currentAnswer.font = .systemFont(ofSize: 44);
        currentAnswer.isUserInteractionEnabled = false; //read only
        view.addSubview(currentAnswer);
        
        let submit = UIButton(type: .system);
        submit.translatesAutoresizingMaskIntoConstraints = false;
        submit.setTitle("Submit", for: .normal)
        //added a button target
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit);
        
        let clear = UIButton(type: .system);
        clear.translatesAutoresizingMaskIntoConstraints = false;
        clear.setTitle("Clear", for: .normal);
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear);
        
        //Container view for the 20 buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            //cluesLable topAnchor starts from the bottomAnchor of scoreLabel
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 100),
            
            //Taking 60% of the width and subtracting 100 for margin left
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6,constant: -100),
            
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            
            //Taking 40% of the width and subtracting 100 for margin right
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4,constant: -100),
            
            //equal height of both labels
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor,constant: 20),
            
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -100),
            //-100 is given so that it doesnt overlap with the clear button
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
           
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor,constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            // more constraints to be added here!
        ])
        //Content hugging priority - 250 is default priority value
        // If this priority is high it means Auto Layout prefers not to stretch it;
        // If this priority is low, it will be more likely to be stretched.
        
        //Also refer Content compression resistance priority for more info
        //not related to our current context
        
        //So, To stretch cluesLabel and answersLabel rather than streching the scoreLabel
        //We set the low priorit to them as below:
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        

        
        //20 Buttons code start
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        
        //20 Buttons code end
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel();
    }


}

