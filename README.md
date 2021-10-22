# Antivirus Detection Dump

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [List of Supported Vendors](#list_of_vendors)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

This project contains the CSV files of malware detection names from Antivirus software, and a PowerShell script for dumping the detection entries.

## Getting Started <a name = "getting_started"></a>

Each subfolder contains dump CSV files with vendor's name and date. File name ends with BASE contains names from a vendor's scan engine, and others may be different depended on the sources of detection (e.g. behavior protection).

### Prerequisites

To run PowerShell Script

1. Download Windows Sysinternals and add to `PATH` or install from [Microsoft Store](https://www.microsoft.com/en-us/p/sysinternals-suite/9p7knl5rwt25).

2. Disable PPL(Protected Processes Light) using [PPLKiller](https://github.com/Mattiwatti/PPLKiller).

3. Disable Self-Protection Module of AV if possible.

## Usage <a name = "usage"></a>

`powershell -executionpolicy bypass -File .\AV_DUMP.ps1 $Name`

## List of Supported Vendors <a name = "list_of_vendors"></a>

| Name         | PPL | Need to Disable SP | Detection Source |
| ------------ | --- | ------------------ | ---------------- |
| Huorong      | No  | No                 | BASE             |
| Kaspersky    | Yes | Yes                | BASE, PDM        |
| Malwarebytes | Yes | No                 | BASE, DDS        |
