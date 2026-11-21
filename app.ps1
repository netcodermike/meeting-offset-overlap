param([Parameter(Mandatory=$true, Position=0)][string] $InputPath)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
function Invoke-Analysis($data) {
    $starts = [System.Collections.Generic.List[int]]::new()
    $ends = [System.Collections.Generic.List[int]]::new()
    foreach ($person in $data['participants']) {
        if ($person.Count -ne 4) { throw 'Name, offset, start and end are required' }
        $offset = [int]$person[1]
        $open = [int]$person[2]
        $close = [int]$person[3]
        if ($offset -lt -720 -or $offset -gt 840 -or $open -lt 0 -or $close -gt 1440 -or $close -le $open) { throw 'Invalid window' }
        $starts.Add($open - $offset)
        $ends.Add($close - $offset)
    }
    if ($starts.Count -eq 0) { throw 'Enter at least one participant' }
    $start = ($starts | Measure-Object -Maximum).Maximum
    $end = ($ends | Measure-Object -Minimum).Minimum
    if ($start -ge $end) { return @{ overlap = $null; minutes = 0 } }
    @{ overlap = @($start, $end); minutes = $end - $start }
}

try {
    $payload = Get-Content -LiteralPath $InputPath -Raw | ConvertFrom-Json -AsHashtable
    if ($payload -isnot [System.Collections.IDictionary]) { throw 'Input must be a JSON object' }
    Invoke-Analysis $payload | ConvertTo-Json -Depth 30 -Compress
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
