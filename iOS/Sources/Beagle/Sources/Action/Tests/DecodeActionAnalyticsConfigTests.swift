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

import XCTest
import Beagle
import SnapshotTesting

final class DecodeActionAnalyticsConfigTests: XCTestCase {

    func testEnabled() throws {
        let enabled = try analyticsFromJson("true")

        XCTAssertEqual(enabled, .enabled(nil))
        assert(enabled, transformsToJson: "true")
    }

    func testDisabled() throws {
        let disabled = try analyticsFromJson("false")

        XCTAssertEqual(disabled, .disabled)
        assert(disabled, transformsToJson: "false")
    }

    func testFromEmptyObject() throws {
        let emptyObject = try analyticsFromJson("{ }")

        XCTAssertEqual(emptyObject, .enabled(.init()))
        assert(emptyObject, transformsToJson: """
        {

        }
        """)
    }

    func testWithAttributes() throws {
        let attributes = ["componentId", "mode", "value[0].text"]
        let analytics = try analyticsFromJson("""
        {
          "attributes": \(attributes)
        }
        """)

        XCTAssertEqual(analytics, .enabled(.init(attributes: attributes)))
        assert(analytics, transformsToJson: """
        {
          "attributes" : [
            "componentId",
            "mode",
            "value[0].text"
          ]
        }
        """)
    }

    func testWithAdditionalEntries() throws {
        let entries = try analyticsFromJson("""
        {
            "additionalEntries": {
                "text": "a text",
                "object": {
                    "key": 2
                }
            }
        }
        """)

        XCTAssertEqual(entries, .enabled(.init(additionalEntries: [
            "text": "a text",
            "object": ["key": 2]
        ])))

        assert(entries, transformsToJson: """
        {
          "additionalEntries" : {
            "object" : {
              "key" : 2
            },
            "text" : "a text"
          }
        }
        """)
    }

    // MARK: - Aux

    private let decoder = JSONDecoder()

    private func analyticsFromJson(_ string: String) throws -> ActionAnalyticsConfig {
        let data = try XCTUnwrap(string.data(using: .utf8))
        return try decoder.decode(ActionAnalyticsConfig.self, from: data)
    }

    private func assert(_ analytics: ActionAnalyticsConfig, transformsToJson string: String, line: UInt = #line) {
        _assertInlineSnapshot(matching: analytics, as: .json, with: string, line: line)
    }
}
