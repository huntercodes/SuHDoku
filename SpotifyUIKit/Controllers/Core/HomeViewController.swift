//
//  ViewController.swift
//  SpotifyUIKit
//
//  Created by hunter downey on 4/27/22.
//

import UIKit

enum HomeSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel])
    case recommendedMusic(viewModels: [NewReleasesCellViewModel])
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [HomeSectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedMusicCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedMusicCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()

        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendedTracks: RecommendationsResponse?
        
        //New Releases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            
            switch result {
                case .success(let model):
                    newReleases = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            
            switch result {
                case .success(let model):
                    featuredPlaylists = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        // Recommended Albums/Genres
        APICaller.shared.getRecommendedGenres { result in
            switch result {
                case .success(let model):
                    let genres = model.genres
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    
                    APICaller.shared.getRecommendations(genres: seeds) { recResult in
                        defer {
                            group.leave()
                        }
                        
                        switch recResult {
                            case .success(let model):
                                recommendedTracks = model
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendedTracks?.tracks else {
                return
            }
            
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
    }
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        
        // Configure Models
        sections.append(.newReleases(
            viewModels: newAlbums.compactMap({
                return NewReleasesCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? "-"
                )
            })
        ))
//        sections.append(.featuredPlaylists(
//            viewModels: newAlbums.compactMap({
//                return NewReleasesCellViewModel(
//                    name: $0.name,
//                    artworkURL: URL(string: $0.images.first?.url ?? ""),
//                    numberOfTracks: $0.total_tracks,
//                    artistName: $0.artists.first?.name ?? "-"
//                )
//            })
//        ))
//        sections.append(.recommendedMusic(
//            viewModels: newAlbums.compactMap({
//                return NewReleasesCellViewModel(
//                    name: $0.name,
//                    artworkURL: URL(string: $0.images.first?.url ?? ""),
//                    numberOfTracks: $0.total_tracks,
//                    artistName: $0.artists.first?.name ?? "-"
//                )
//            })
//        ))
        
        collectionView.reloadData()
    }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .newReleases(let viewModels):
                return viewModels.count
            case .featuredPlaylists(let viewModels):
                return viewModels.count
            case .recommendedMusic(let viewModels):
                return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            case .newReleases(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                    for: indexPath
                ) as? NewReleaseCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                let viewModel = viewModels[indexPath.row]
            
                cell.configure(with: viewModel)
                return cell
            case .featuredPlaylists(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                    for: indexPath
                ) as? FeaturedPlaylistCollectionViewCell else {
                    return UICollectionViewCell()
                }
            
                // let viewModel = viewModels[indexPath.row]
            
                cell.backgroundColor = .yellow
                return cell
            case .recommendedMusic(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecommendedMusicCollectionViewCell.identifier,
                    for: indexPath
                ) as? RecommendedMusicCollectionViewCell else {
                    return UICollectionViewCell()
                }
            
                // let viewModel = viewModels[indexPath.row]
            
                cell.backgroundColor = .green
                return cell
        }
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
            case 0:
                // New Releases Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // New Releases Vertical Group inside of Horizontal Group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
                    subitem: item,
                    count: 3
                )
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(390)),
                    subitem: verticalGroup,
                    count: 1
                )

                // New Releases Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
                
            case 1:
                // Featured Playlists Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(180))
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Featured Playlists Vertical Group inside of Horizontal Group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(360)),
                    subitem: item,
                    count: 2
                )
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(360)),
                    subitem: verticalGroup,
                    count: 1
                )

                // Featured Playlists Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            case 2:
                // Recommended Music Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Recommended Music Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90)),
                    subitem: item,
                    count: 1
                )

                // Recommended Music Section
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            default:
                // Default Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Default Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(390)),
                    subitem: item,
                    count: 1
                )

                // Default Section
                let section = NSCollectionLayoutSection(group: group)
                return section
        }
    }
}
