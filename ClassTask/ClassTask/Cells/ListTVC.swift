import SnapKit
import UIKit

final class ListTVC: UITableViewCell {
    static let reuseIdentifier = String(describing: ListTVC.self)
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = .label
        return lbl
    }()

    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = .label
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ListTVC.reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    func configure(_ list: List) {
        nameLabel.text = list.name
        priceLabel.text = list.formattedPrice + " AZN"
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-8)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.verticalEdges.equalToSuperview().inset(20)
        }
    }
}
