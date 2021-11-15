# Antivirus Detection Dump

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [List of Supported Vendors](#list_of_vendors)
- [Contributing](CONTRIBUTING.md)

## About <a name = "about"></a>

This project contains the CSV files of malware detection names from some antivirus products, and a PowerShell script for dumping the detection entries.

## Getting Started <a name = "getting_started"></a>

Each subfolder contains dump CSV files with vendor's name and date. File name ends with BASE contains names from a vendor's scan engine, and others may be different depended on the sources of detection (e.g. behavior protection).

### Prerequisites

To run the PowerShell script:

1. Download the [Windows Sysinternals](https://docs.microsoft.com/sysinternals/downloads/sysinternals-suite) and add it to `PATH`, or install it from [Microsoft Store](https://www.microsoft.com/p/sysinternals-suite/9p7knl5rwt25).

2. Disable the PPL (Protected Processes Light) using [PPLKiller](https://github.com/Mattiwatti/PPLKiller), or use Microsoft Windows 7 (it does not serve the PPL).

3. Disable Self-Protection Module of AV if possible.

Note: You may need to [updating the PowerShell](https://www.microsoft.com/download/details.aspx?id=54616) (v4.0 or later) and [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework) (v4.5 or later) in order to run this script in Windows 7.

## Usage <a name = "usage"></a>

`powershell -executionpolicy bypass -File .\AV_DUMP.ps1 <Name>`

## List of Supported Vendors <a name = "list_of_vendors"></a>

| Name         | PPL | Need to Disable SP | Detection Source | Accuracy |
| ------------ | --- | ------------------ | ---------------- | -------- |
| Huorong      | No  | No                 | BASE             | High     |
| Kaspersky    | Yes | Yes                | BASE, PDM        | Medium   |
| Malwarebytes | Yes | No                 | BASE, DDS        | High     |
