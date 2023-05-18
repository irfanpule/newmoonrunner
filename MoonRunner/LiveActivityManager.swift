//
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import ActivityKit

enum LiveActivityManagerError: Error {
    case failedToGetId
}

@available(iOS 16.1, *)
class LiveActivityManager {

    @discardableResult
    static func startActivity(distance: String, time: String) throws -> String {
        var activity: Activity<RunningAttributes>?
        let initialState = RunningAttributes.ContentState(distance: distance, time: time)
      
        do {
            activity = try Activity.request(attributes: RunningAttributes(),
                                            contentState: initialState,
                                            pushType: nil)
            guard let id = activity?.id else { throw LiveActivityManagerError.failedToGetId }
            return id
        } catch {
            throw error
        }
    }
  
    static func updateActivity(id: String, distance: String, time: String) async {
        let updatedContentState = RunningAttributes.ContentState(distance: distance, time: time)
        let activity = Activity<RunningAttributes>.activities.first(where: { $0.id == id })
        await activity?.update(using: updatedContentState)
    }
  
    static func endActivity(_ id: String) async {
          await Activity<RunningAttributes>.activities.first(where: { $0.id == id })?.end(dismissalPolicy: .immediate)
    }

}
