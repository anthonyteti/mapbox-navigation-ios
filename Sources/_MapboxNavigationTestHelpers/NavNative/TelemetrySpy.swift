@testable import MapboxNavigationCore
import MapboxNavigationNative_Private

class TelemetrySpy: Telemetry {
    var postCustomEventCalled = false
    var postOuterDeviceEventCalled = false
    var startBuildUserFeedbackMetadataCalled = false
    var postUserFeedbackCalled = false
    var onChangeApplicationStateCalled = false

    var returnedUserFeedbackHandle: UserFeedbackHandle
    var passedAction: OuterDeviceAction?
    var passedUserFeedback: MapboxNavigationNative_Private.UserFeedback?
    var passedUserFeedbackCallback: UserFeedbackCallback?
    var passedFeedbackMetadata: UserFeedbackMetadata?

    init() {
        let navigator = NativeNavigatorSpy()
        let telemetry = navigator.getTelemetryForEventsMetadataProvider(EventsMetadataInterfaceSpy())
        self.returnedUserFeedbackHandle = telemetry.startBuildUserFeedbackMetadata()
    }

    func postCustomEvent(forType type: String, version: String, payload: String?) {
        postCustomEventCalled = true
    }

    func postOuterDeviceEvent(for action: OuterDeviceAction) {
        postOuterDeviceEventCalled = true
        passedAction = action
    }

    func startBuildUserFeedbackMetadata() -> UserFeedbackHandle {
        startBuildUserFeedbackMetadataCalled = true
        return returnedUserFeedbackHandle
    }

    func postUserFeedback(
        for feedbackMetadata: UserFeedbackMetadata,
        userFeedback: MapboxNavigationNative_Private.UserFeedback,
        callback: @escaping UserFeedbackCallback
    ) {
        postUserFeedbackCalled = true
        passedFeedbackMetadata = feedbackMetadata
        passedUserFeedback = userFeedback
        passedUserFeedbackCallback = callback
    }

    func onChangeApplicationState(forAppState appState: ApplicationState) {
        onChangeApplicationStateCalled = true
    }
}

extension UserFeedbackMetadata {
    public static func mock(
        feedbackId: String = "",
        locationsBefore: [FixLocation] = [],
        locationsAfter: [FixLocation] = [],
        step: Step? = nil
    ) -> Self {
        .init(
            feedbackId: feedbackId,
            locationsBefore: locationsBefore,
            locationsAfter: locationsAfter,
            step: step
        )
    }
}

class NativeUserFeedbackHandleSpy: NativeUserFeedbackHandle, @unchecked Sendable {
    var returnedUserFeedbackMetadata: UserFeedbackMetadata = .mock()

    func getMetadata() -> UserFeedbackMetadata {
        returnedUserFeedbackMetadata
    }
}

final class EventsMetadataInterfaceSpy: EventsMetadataInterface {
    func provideEventsMetadata() -> EventsMetadata {
        .init(
            volumeLevel: nil,
            audioType: nil,
            screenBrightness: nil,
            percentTimeInForeground: nil,
            percentTimeInPortrait: nil,
            batteryPluggedIn: nil,
            batteryLevel: nil,
            connectivity: "",
            appMetadata: nil
        )
    }
}
