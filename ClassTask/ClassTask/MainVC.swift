import SnapKit
import UIKit

final class MainVC: UIViewController {
    private lazy var expencesTableView: UITableView = {
        let tv = UITableView()

        tv.register(ListTVC.self, forCellReuseIdentifier: ListTVC.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    private let seperator: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        return v
    }()

    private let totalView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        return v
    }()

    private let totalTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total: "
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .label
        return lbl
    }()

    private let totalNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()

    private var lists: [List] = StorageManager.shared.loadData()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        title = "Expences"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(openDetailsVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .done, target: self, action: #selector(deleteLists))
        addSubViews()
        addConstraints()
        let totalPrice = lists.reduce(0) { $0 + $1.price }
        totalNameLabel.text = String(format: "%.2f AZN", Double(totalPrice))
    }

    private func addSubViews() {
        view.addSubview(expencesTableView)
        view.addSubview(seperator)
        view.addSubview(totalView)
        totalView.addSubview(totalNameLabel)
        totalView.addSubview(totalTextLabel)
    }

    private func addConstraints() {
        expencesTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(seperator.snp.top)
        }
        seperator.snp.makeConstraints { make in
            make.bottom.equalTo(totalView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        totalView.snp.makeConstraints { make in
//            make.height.equalTo(80)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        totalTextLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(30)
            make.leading.equalToSuperview().offset(12)
        }
        totalNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.verticalEdges.equalToSuperview().inset(30)
        }
    }

    @objc private func openDetailsVC() {
        let detailVC = DetailVC()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc private func deleteLists() {
        StorageManager.shared.clearFile()
        lists = []
        expencesTableView.reloadData()
        totalNameLabel.text = "0.00 AZN"
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, closure in
            self?.lists.remove(at: indexPath.row)
            tableView.reloadData()
            StorageManager.shared.clearFile()
            closure(true)
            let totalPrice = self?.lists.reduce(0) { $0 + $1.price }
            self?.totalNameLabel.text = String(format: "%.2f AZN", Double(totalPrice ?? 0))
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}

extension MainVC: AddListDelegate {
    func didAddList(_ list: List) {
        lists.append(list)

        StorageManager.shared.saveData(lists)

        expencesTableView.reloadData()
        let totalPrice = lists.reduce(0) { $0 + $1.price }
        totalNameLabel.text = String(format: "%.2f AZN", Double(totalPrice))
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTVC.reuseIdentifier, for: indexPath) as? ListTVC
        guard let cell else { return UITableViewCell() }

        cell.configure(lists[indexPath.row])

        return cell
    }
}
