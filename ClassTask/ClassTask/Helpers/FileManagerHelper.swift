import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private init() {}

    private let manager = FileManager.default

    private var listUrl: URL? {
        manager.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("lists.json")
    }

    func loadData() -> [List] {
        guard let listUrl else { return [] }

        print(listUrl)
        do {
            let data = try Data(contentsOf: listUrl)

            if let arr = try? JSONDecoder().decode([List].self, from: data) {
                return arr
            }

            if let single = try? JSONDecoder().decode(List.self, from: data) {
                return [single]
            }

            print("Decode error: unknown format")
            return []
        } catch {
            return []
        }
    }

    func saveData(_ data: [List]) {
        guard let listUrl else { return }

        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: listUrl)
        } catch {
            print("Save error:", error)
        }
    }

    func clearFile() {
        guard let listUrl else { return }

        do {
            try Data().write(to: listUrl)
            print("File content cleared")
        } catch {
            print("Clear error:", error)
        }
    }
}
