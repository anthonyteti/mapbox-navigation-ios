import CoreLocation
import Foundation
import MapboxDirections
import Turf

extension Route {
    public static func mock(
        legs: [RouteLeg] = [.mock()],
        shape: LineString? = nil,
        distance: LocationDistance = 300,
        expectedTravelTime: TimeInterval = 195,
        typicalTravelTime: TimeInterval? = 200,
        speechLocale: Locale? = .current
    ) -> Self {
        var route = self.init(
            legs: legs,
            shape: shape,
            distance: distance,
            expectedTravelTime: expectedTravelTime,
            typicalTravelTime: typicalTravelTime
        )
        route.speechLocale = speechLocale
        return route
    }
}

extension RouteLeg {
    public static func mock(
        steps: [RouteStep] = [
            .mock(maneuverType: .depart),
            .mock(maneuverType: .useLane),
            .mock(maneuverType: .continue),
            .mock(maneuverType: .arrive),
        ],
        name: String = "",
        distance: LocationDistance = 300,
        expectedTravelTime: TimeInterval = 195,
        profileIdentifier: ProfileIdentifier = .automobile,
        destination: Waypoint? = .mock()
    ) -> Self {
        var leg = self.init(
            steps: steps,
            name: name,
            distance: distance,
            expectedTravelTime: expectedTravelTime,
            profileIdentifier: profileIdentifier
        )
        leg.source = if let coordinate = steps.first?.maneuverLocation {
            .init(coordinate: coordinate)
        } else { .mock() }
        leg.destination = destination
        return leg
    }
}

extension Waypoint {
    public static func mock(
        coordinate: LocationCoordinate2D = .init(latitude: 1, longitude: 2)
    ) -> Self {
        self.init(coordinate: coordinate)
    }
}

extension RouteStep {
    public static func mock(
        transportType: TransportType = .automobile,
        maneuverLocation: LocationCoordinate2D = .init(latitude: 1, longitude: 2),
        maneuverType: ManeuverType = .turn,
        instructions: String = "",
        drivingSide: DrivingSide = .right,
        distance: LocationDistance = 100,
        expectedTravelTime: TimeInterval = 65,
        instructionsDisplayedAlongStep: [VisualInstructionBanner]? = nil,
        administrativeAreaContainerByIntersection: [Int?]? = [0],
        segmentIndicesByIntersection: [Int?]? = [0]
    ) -> Self {
        var step = self.init(
            transportType: transportType,
            maneuverLocation: maneuverLocation,
            maneuverType: maneuverType,
            instructions: instructions,
            drivingSide: drivingSide,
            distance: distance,
            expectedTravelTime: expectedTravelTime,
            intersections: [.mock()],
            instructionsDisplayedAlongStep: instructionsDisplayedAlongStep,
            administrativeAreaContainerByIntersection: administrativeAreaContainerByIntersection,
            segmentIndicesByIntersection: segmentIndicesByIntersection
        )
        step.shape = .init([maneuverLocation, maneuverLocation])
        return step
    }
}

extension Intersection {
    public static func mock() -> Self {
        return .init(
            location: .init(
                latitude: 1,
                longitude: 2
            ),
            headings: [90],
            approachIndex: 0,
            outletIndex: 0,
            outletIndexes: .init(integer: 0),
            approachLanes: nil,
            usableApproachLanes: nil,
            preferredApproachLanes: nil,
            usableLaneIndication: nil
        )
    }
}
