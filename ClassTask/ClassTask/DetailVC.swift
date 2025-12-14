import SnapKit
import UIKit

protocol AddListDelegate: AnyObject {
    func didAddList(_ list: List)
}

final class DetailVC: UIViewController {
    weak var delegate: AddListDelegate?
    static let reuseIdentifier = String(describing: DetailVC.self)
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "Expense Name"
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        return lbl
    }()

    private let nameTextField: UITextField = {
        let tf = InsetTextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.backgroundColor = .systemGray6
        tf.placeholder = "e.g., Groceries"
        tf.clipsToBounds = true
        tf.addTarget(nil, action: #selector(tfEditingBegan(_:)), for: .editingDidBegin)
        tf.addTarget(nil, action: #selector(tfEditingEnded(_:)), for: .editingDidEnd)
        return tf
    }()

    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "Amount"

        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        return lbl
    }()

    private let priceTextField: UITextField = {
        let tf = InsetTextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.backgroundColor = .systemGray6
        tf.placeholder = "0.00"
        tf.keyboardType = .numberPad
        tf.clipsToBounds = true
        tf.addTarget(nil, action: #selector(tfEditingBegan(_:)), for: .editingDidBegin)
        tf.addTarget(nil, action: #selector(tfEditingEnded(_:)), for: .editingDidEnd)
        return tf
    }()

    private let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .dynamic
        config.baseForegroundColor = .white
        config.title = "Save"
        let btn = UIButton(configuration: config)
        btn.layer.cornerRadius = 16
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.clipsToBounds = true
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        addSubViews()
        setupConstraints()
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }

    private func addSubViews() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    @objc private func textFieldsDidChange() {
        let isNameValid = !(nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isPriceValid = !(priceTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)

        let isFormValid = isNameValid && isPriceValid

        saveButton.isEnabled = isFormValid
        saveButton.alpha = isFormValid ? 1.0 : 0.5
    }

    @objc private func tfEditingBegan(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.systemBlue.cgColor
    }

    @objc private func tfEditingEnded(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.systemGray4.cgColor
    }

    @objc private func save() {
        guard
            let name = nameTextField.text, !name.isEmpty,
            let priceText = priceTextField.text,
            let price = Double(priceText.trimmingCharacters(in: .whitespaces))
        else {
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            let alertController = UIAlertController(title: "Invalid Input", message: "Type numbers", preferredStyle: .alert)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }

        let list = List(name: name, price: price)

        delegate?.didAddList(list)
        navigationController?.popViewController(animated: true)
    }
}
