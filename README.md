# Presentation templates

Two reusable scenario templates for [Presentation](https://www.neurobs.com/) (Neurobehavioral Systems), written while preparing a lab protocol.

| Folder | What it does |
|---|---|
| `questionnaire/` | Questionnaire with three response types: Likert (keys 1–7), **free text typed on the keyboard** (confirmed with ENTER) and yes/no |
| `vas/` | Mouse-driven Visual Analogue Scale: the participant moves a cursor along a line and clicks to confirm; any number of VAS in sequence |

Both templates append the answers to a `;`-separated CSV (`subject;item;answer`) and read the instruction and goodbye texts from EXPARAM, so they can be changed without touching the code.

## Use

1. Open the `.sce` file and replace the placeholder items in the `CONFIGURATION` block. The number of items is read from the arrays.
2. Create a new experiment in Presentation pointing to the scenario.
3. Set the two EXPARAM string parameters below.
4. Set the response devices in **Settings → Response**:
   - VAS: add the mouse (left button = *Pulsante/Button 0*) and press **Use Mouse** so it appears among the axis devices.
   - Questionnaire: add the keyboard keys 1–7 as active buttons, in this order.
5. Run.

Items of published questionnaires are not included, as they are protected by their authors' copyright: add yours with the proper permission and citation.

## Parameters

| Parameter | Where | Meaning |
|---|---|---|
| `instructions` | EXPARAM (string) | Text of the first screen |
| `end` | EXPARAM (string) | Text of the final screen |
| `output_name` | PCL configuration | Output CSV file name |
| `active_buttons` / `button_codes` | scenario header | Questionnaire: keys 1–7; VAS: left mouse button |
| `LINE_WIDTH` | VAS configuration | Width of the scale line in screen units (must match the box) |
| `MOUSE_RANGE` | VAS configuration | Mouse movement needed to cross the line (sensitivity) |
| `SCORE_MAX` | VAS configuration | Rating range, 0 to `SCORE_MAX` (default 100) |
| `max_y = 100` | scenario header | Sizes and positions are in screen-independent units, so the layout adapts to any display |

Developed on Presentation 25.1. Check on your own setup before use.

## Data

Participant data (`Logfiles/`, `*.log`, `*_results.csv`) are excluded via `.gitignore` and must never be committed.

## License

[EUPL-1.2](https://interoperable-europa.ec.europa.eu/collection/eupl/eupl-text-eupl-12) (European Union Public Licence)
