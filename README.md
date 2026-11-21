# Meeting Offset Overlap

Intersect everyone’s working window after converting local minute ranges to one UTC timeline.

![Sample run from Meeting Offset Overlap](docs/demo.webp)

## Run

Install PowerShell 7 or newer. Run these commands from the repository root.

```sh
pwsh -NoProfile -File app.ps1 sample.json
```

Replace `sample.json` with a JSON file following the same structure. The app prints a JSON report to standard output.

Each record has a name, fixed UTC offset in minutes, local start minute, and local end minute. Offset changes are entered explicitly.

## Verify

Run `python check.py` with Python 3.11 or newer after the build step when applicable. The check verifies the bundled scenario and confirms that an invalid input returns an error.
