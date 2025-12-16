<# 
월요일 기준 주차 폴더 생성 스크립트
- 현재 달부터 해당 연도 12월까지
- 주 단위: 월요일~일요일
- 폴더 구조: YYYY-MM/1week(yy.MM.dd~yy.MM.dd)
#>

param()

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Get-WeekRangesForMonth {
    param(
        [int]$Year,
        [int]$Month
    )

    $firstDay = Get-Date -Year $Year -Month $Month -Day 1
    $lastDay = ($firstDay).AddMonths(1).AddDays(-1)

    # 첫 번째 월요일 (DayOfWeek: Monday = 1)
    $daysUntilMonday = ([int][System.DayOfWeek]::Monday - [int]$firstDay.DayOfWeek) % 7
    $firstMonday = $firstDay.AddDays($daysUntilMonday)

    $ranges = @()
    $weekStart = $firstMonday
    while ($weekStart -le $lastDay) {
        $weekEnd = $weekStart.AddDays(6)  # 월/년 경계 무시하고 일요일까지
        $ranges += ,@($weekStart, $weekEnd)
        $weekStart = $weekStart.AddDays(7)
    }

    return $ranges
}

$today = Get-Date
$startYear = $today.Year
$startMonth = $today.Month
$endYear = $today.Year
$endMonth = 12

for ($year = $startYear; $year -le $endYear; $year++) {
$monthStart = if ($year -eq $startYear) { $startMonth } else { 1 }
$monthEnd = if ($year -eq $endYear) { $endMonth } else { 12 }

    for ($month = $monthStart; $month -le $monthEnd; $month++) {
        $monthFolder = "{0}-{1:D2}" -f $year, $month
        if (-not (Test-Path $monthFolder)) {
            [System.IO.Directory]::CreateDirectory($monthFolder) | Out-Null
        }

        $ranges = Get-WeekRangesForMonth -Year $year -Month $month
        $weekNumber = 1
        foreach ($range in $ranges) {
            $startStr = $range[0].ToString("yy.MM.dd")
            $endStr = $range[1].ToString("yy.MM.dd")
            $weekFolderName = "{0}week({1}~{2})" -f $weekNumber, $startStr, $endStr
            $weekFolderPath = Join-Path $monthFolder $weekFolderName

            if (-not (Test-Path $weekFolderPath)) {
                [System.IO.Directory]::CreateDirectory($weekFolderPath) | Out-Null
            }

            $weekNumber++
        }
    }
}

Write-Host "완료: $startYear년 $startMonth월부터 $endYear년 12월까지 (월~일, 월/년 경계 무시) 주차 폴더를 생성했습니다."

