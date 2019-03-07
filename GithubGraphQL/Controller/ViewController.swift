import UIKit
import Apollo

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var viewModel: GraphQLSearchViewModel!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    activitySpinner.hidesWhenStopped = true
        
    activitySpinner.startAnimating()
        
    resultsTableView.isHidden = true
    resultsTableView.separatorColor = UIColor.darkGray
    resultsTableView.dataSource = self
    resultsTableView.prefetchDataSource = self
        
    viewModel = GraphQLSearchViewModel(delegate: self)
    
    viewModel.fetchGraphQLData()
  }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultsCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.searchGQLDataResult(at: indexPath.row))
        }
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexPathsForVisibleRows = resultsTableView.indexPathsForVisibleRows
        if (indexPathsForVisibleRows?.contains(where: isLoadingCell))! {
            viewModel.fetchGraphQLData()
        }
    }
}

extension ViewController: GraphQLSearchViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activitySpinner.stopAnimating()
            resultsTableView.isHidden = false
            resultsTableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        //resultsTableView.reloadRows(at: indexPathsToReload, with: .automatic)
        resultsTableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        activitySpinner.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        let alertController = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

private extension ViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount 
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = resultsTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
