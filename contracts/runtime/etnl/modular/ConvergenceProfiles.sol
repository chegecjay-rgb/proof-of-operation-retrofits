// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library ConvergenceProfiles {
    enum ConvergenceProfile {
        SCP_FRAGMENTED_DISCLOSURE,
        SCP_HOSTILE_ORDERING,
        SCP_DUPLICATE_SURFACE,
        SCP_EQUIVALENCE_COLLISION,
        SCP_TOPOLOGY_FRAGMENTATION
    }

    struct ProfileConfiguration {
        bool fragmentedDisclosure;
        bool hostileOrdering;
        bool duplicateSurface;
        bool equivalenceCollision;
        bool topologyFragmentation;
    }

    function profileConfiguration(ConvergenceProfile profile)
        internal
        pure
        returns (ProfileConfiguration memory config)
    {
        if (profile == ConvergenceProfile.SCP_FRAGMENTED_DISCLOSURE) {
            config.fragmentedDisclosure = true;
        }

        if (profile == ConvergenceProfile.SCP_HOSTILE_ORDERING) {
            config.hostileOrdering = true;
        }

        if (profile == ConvergenceProfile.SCP_DUPLICATE_SURFACE) {
            config.duplicateSurface = true;
        }

        if (profile == ConvergenceProfile.SCP_EQUIVALENCE_COLLISION) {
            config.equivalenceCollision = true;
        }

        if (profile == ConvergenceProfile.SCP_TOPOLOGY_FRAGMENTATION) {
            config.topologyFragmentation = true;
        }
    }
}
