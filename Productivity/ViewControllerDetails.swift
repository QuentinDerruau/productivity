import UIKit

protocol MyDelegate {
    func fetchData()
}

class DetailViewController: UIViewController {

    weak var viewController: ViewController?
    var delegate: MyDelegate?
    var tasks = [Task]()
    var tasksDone = [Task]()

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var priorityInput: UIButton!
    @IBOutlet weak var reccurencySwitch: UISwitch!

    private var actualTaskIndex: Int = 0 // Assuming this is declared somewhere

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataDetails()
        setupPriorityInput()
        configureUIForTask(at: actualTaskIndex)
    }

    // MARK: - Actions

    @IBAction func switchReccurrency(_ sender: Any) {
        let taskToUpdate = actualTask()
        DatabaseService.shared.updateTaskReccurency(task: taskToUpdate, newTaskReccurency: reccurencySwitch.isOn)
        delegate?.fetchData()
    }

    @IBAction func datePickerUpdate(_ sender: Any) {
        let taskToUpdate = actualTask()
        DatabaseService.shared.updateTaskDate(task: taskToUpdate, newTaskDate: datePicker.date)
        delegate?.fetchData()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func nameTaskAction(_ sender: Any) {
        guard let taskName = titleInput.text else { return }
        let taskToUpdate = actualTask()
        DatabaseService.shared.updateTaskName(task: taskToUpdate, newTaskName: taskName)
        delegate?.fetchData()
    }

    @IBAction func detailInput(_ sender: Any) {
        guard let taskDetails = detailText.text else { return }
        let taskToUpdate = actualTask()
        DatabaseService.shared.updateTaskDetails(task: taskToUpdate, newTaskDetails: taskDetails)
    }

    // MARK: - Helper Methods

    private func actualTask() -> Task {
        return actualTaskIndex == 0 ? tasks[actualTaskIndex] : tasksDone[actualTaskIndex]
    }

    private func fetchDataDetails() {
        DatabaseService.shared.fetchTasks { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.tasks = data.filter { $0.finished == true && Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .day) || $0.reccurency == true }
                self.tasksDone = data.filter { $0.finished == false && Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .day) || $0.reccurency == true }
            }
        }
    }

    private func setupPriorityInput() {
        priorityInput.menu = UIMenu(children: [
            UIAction(title: "Low", handler: { [weak self] _ in self?.updateTaskPriority(with: "Low") }),
            UIAction(title: "Medium", handler: { [weak self] _ in self?.updateTaskPriority(with: "Medium") }),
            UIAction(title: "High", handler: { [weak self] _ in self?.updateTaskPriority(with: "High") }),
            UIAction(title: "Critical", handler: { [weak self] _ in self?.updateTaskPriority(with: "Critical") })
        ])
    }

    private func updateTaskPriority(with priority: String) {
        let taskToUpdate = actualTask()
        DatabaseService.shared.updateTaskPriority(task: taskToUpdate, newTaskPriority: priority)
        delegate?.fetchData()
    }

    private func configureUIForTask(at index: Int) {
        let task = actualTask()
        titleInput.text = task.name
        detailText.text = task.details
        reccurencySwitch.isOn = task.reccurency
        datePicker.date = task.date

        if let priority = task.priority, let action = priorityInput.menu?.children.compactMap({ $0 as? UIAction }).first(where: { $0.title == priority }) {
            action.state = .on
        } else {
            if let action = priorityInput.menu?.children.first as? UIAction {
                action.state = .on
            }
        }
    }
}
