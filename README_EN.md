# FiveM Binoculars Script

## Description

This script implements a realistic binoculars mode for FiveM, allowing players to look through binoculars. It provides zoom functions, camera rotation, and disables interfering controls for an immersive experience. The script supports both on-foot and in-vehicle use, with special adjustments for vehicles.

## Features

- **Zoom Functionality**: Zoom in and out with the mouse wheel (on foot) or keys (in vehicle).
- **Camera Rotation**: Move the camera with the mouse for horizontal and vertical rotation.
- **Control Disabling**: Disables weapon wheel, radio wheel, and other interfering inputs during use.
- **Vehicle Support**: Works in vehicles with limited rotation for safety.
- **Visual Effects**: Applies timecycle modifiers to simulate a binoculars effect.
- **Item Integration**: Activates automatically when the "Fernglas" item is held in hand.

## Installation

1. Download the `binoculars` folder into your FiveM `resources` folder.
2. Ensure the dependency `rpfx-core` is installed and started in your `server.cfg`.
3. Add `start binoculars` to your `server.cfg`.
4. Restart your server or load the resource with `/refresh` and `/start binoculars`.

## Configuration

Edit the `config.lua` file to customize behavior:

### Zoom Settings
- `fov_max` (Default: 70.0): Maximum Field of View (higher value = less zoom).
- `fov_min` (Default: 5.0): Minimum Field of View (lower value = more zoom).
- `zoomspeed` (Default: 10.0): Zoom speed (higher values = faster zoom).

### Camera Movement
- `speed_lr` (Default: 8.0): Speed of horizontal camera movement (left-right).
- `speed_ud` (Default: 8.0): Speed of vertical camera movement (up-down).

### Movement and Vehicle
- `allowMovement` (Default: false): Allows the player to move with WASD while binoculars are active.
- `allowInVehicle` (Default: true): Allows use of binoculars in vehicles (with rotation limits).

### Visual Effects
- `timecycle` (Default: "glasses_green"): The timecycle modifier for visual effect.
- `timecycleStrength` (Default: 0.5): Strength of the timecycle effect (0.0 to 1.0).

## Usage

- Take the item named "Fernglas" in hand (via the rpfx-core system).
- Binoculars activate automatically.
- Use the mouse wheel to zoom and mouse to rotate.
- Press the binoculars key again or switch items to exit the mode.

## Dependencies

- [rpfx-core](https://discord.gg/yqcMY2VaPq): For item handling and UI integration.

## Known Issues

- In vehicles, rotation is limited to prevent crashes.
- Ensure no other scripts override the same controls.

## License

This script is licensed under the MIT License. See LICENSE file for details.
</content>