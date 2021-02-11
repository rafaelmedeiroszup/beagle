/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// MARK: - Dependency

public protocol DependencyAnalyticsExecutor {

    /// Set this property to receive analytics info when Beagle actions occur
    var analyticsProvider: AnalyticsProvider? { get }

    /// DEPRECATED
    var analytics: Analytics? { get }
}

// MARK: - Provider

public protocol AnalyticsProvider {

    /// Beagle uses this configuration to know how to handle analytics events, and so this method will be called on every triggered event,
    /// in order to access the most updated global analytics config.
    /// When `nil`, Beagle will temporarily cache records to send them when there is a new config.
    func getConfig() -> AnalyticsConfig?

    /// Beagle will call this method to provide you with a record (`AnalyticsRecord`) generated for an event.
    /// If you don't want to send one request for each analytics generated by Beagle, it is a good idea to implement a batch mechanism within this function.
    func createRecord(_ record: AnalyticsRecord)

    /// Represents how many records will be temporarily stored in a queue while `getConfig()` is `nil`. Defaults to `100`.
    var maximumItemsInQueue: Int? { get }
}
