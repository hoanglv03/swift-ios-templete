//
//  AppSchema.swift
//  SingerApp

import SwiftData

enum DBModel { }

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
            DBModel.Country.self,
            DBModel.CountryDetails.self,
            DBModel.Currency.self,
        ], version: actualVersion)
    }
}
