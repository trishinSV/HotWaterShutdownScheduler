//
//  FileService.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation
import Zip

protocol FileServiceProtocol: AnyObject {

    // MARK: - Private

    func decode(file: String, completeion: (Result<AddressList, HWSSError>) -> Void)
}

final class FileService: FileServiceProtocol {

    // MARK: - Private

    private init() {}

    // MARK: - Public

    static let shared: FileServiceProtocol = FileService()

    func decode(file: String, completeion: (Result<AddressList, HWSSError>) -> Void) {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("file.zip"),
            let decodedData = Data(base64Encoded: file) else { return completeion(.failure(.diskError)) }
        do {
            try decodedData.write(to: url)
            let unzipDirectory = try Zip.quickUnzipFile(url)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: unzipDirectory, includingPropertiesForKeys: nil)

            guard let path = directoryContents.first else { return completeion(.failure(.diskError)) }
            let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
            return completeion(.success(try JSONDecoder().decode(AddressList.self, from: jsonData)))
        } catch {
            return completeion(.failure(.decodingError))
        }
    }
}
