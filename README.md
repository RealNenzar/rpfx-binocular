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

# FiveM Fernglas Script

## Beschreibung

Dieses Script implementiert einen realistischen Fernglas-Modus für FiveM, der es Spielern ermöglicht, durch ein Fernglas zu schauen. Es bietet Zoom-Funktionen, Kamerarotation und deaktiviert störende Controls, um ein immersives Erlebnis zu schaffen. Das Script unterstützt sowohl zu Fuß als auch im Fahrzeug, mit speziellen Anpassungen für Fahrzeuge.

## Features

- **Zoom-Funktionalität**: Zoome rein und raus mit dem Mausrad (zu Fuß) oder Tasten (im Fahrzeug).
- **Kamerarotation**: Bewege die Kamera mit der Maus für horizontale und vertikale Rotation.
- **Control-Deaktivierung**: Deaktiviert Waffenrad, Radio-Wheel und andere störende Eingaben während der Nutzung.
- **Fahrzeug-Unterstützung**: Funktioniert im Fahrzeug mit begrenzter Rotation, um Sicherheit zu gewährleisten.
- **Visuelle Effekte**: Wendet Timecycle-Modifier an, um einen Fernglas-Effekt zu simulieren.
- **Item-Integration**: Aktiviert sich automatisch, wenn das "Fernglas"-Item in der Hand gehalten wird.

## Installation

1. Lade den `binoculars`-Ordner in deinen FiveM `resources` Ordner.
2. Stelle sicher, dass die Abhängigkeit `rpfx-core` installiert und in deiner `server.cfg` gestartet ist.
3. Füge `start binoculars` zu deiner `server.cfg` hinzu.
4. Starte deinen Server neu oder lade die Ressource mit `/refresh` und `/start binoculars`.

## Konfiguration

Bearbeite die `config.lua` Datei, um das Verhalten anzupassen:

### Zoom-Einstellungen
- `fov_max` (Standard: 70.0): Maximale Field of View (größerer Wert = weniger Zoom).
- `fov_min` (Standard: 5.0): Minimale Field of View (kleinerer Wert = mehr Zoom).
- `zoomspeed` (Standard: 10.0): Geschwindigkeit des Zooms (höhere Werte = schnellerer Zoom).

### Kamerabewegung
- `speed_lr` (Standard: 8.0): Geschwindigkeit der horizontalen Kamerabewegung (links-rechts).
- `speed_ud` (Standard: 8.0): Geschwindigkeit der vertikalen Kamerabewegung (hoch-runter).

### Bewegung und Fahrzeug
- `allowMovement` (Standard: false): Erlaubt dem Spieler, sich mit WASD zu bewegen, während das Fernglas aktiv ist.
- `allowInVehicle` (Standard: true): Erlaubt die Nutzung des Fernglases im Fahrzeug (mit Rotationslimits).

### Visuelle Effekte
- `timecycle` (Standard: "glasses_green"): Der Timecycle-Modifier für den visuellen Effekt.
- `timecycleStrength` (Standard: 0.5): Stärke des Timecycle-Effekts (0.0 bis 1.0).

## Verwendung

- Nimm das Item namens "Fernglas" in die Hand (über das rpfx-core System).
- Das Fernglas aktiviert sich automatisch.
- Verwende das Mausrad zum Zoomen und die Maus zum Rotieren.
- Drücke die Fernglas-Taste erneut oder wechsle das Item, um den Modus zu beenden.

## Abhängigkeiten

- [rpfx-core](https://discord.gg/yqcMY2VaPq): Für Item-Handling und UI-Integration.

## Bekannte Probleme

- Im Fahrzeug ist die Rotation begrenzt, um Abstürze zu vermeiden.
- Stelle sicher, dass keine anderen Scripts die gleichen Controls überschreiben.

## Lizenz

Dieses Script ist unter der MIT License lizenziert. Siehe LICENSE-Datei für Details.

---

# FiveM Binoculars Script (English)

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