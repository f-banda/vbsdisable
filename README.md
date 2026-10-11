# Disable VBS for Kernel-Level Software Compatibility

A script very useful for support roles, utilizes Microsoft's **Device Guard and Credential Guard hardware readiness tool (DG Readiness Tool) v3.6**. It automates downloading and extracting the Microsoft utility, then runs its `-Disable` option to help troubleshoot compatibility issues involving Windows virtualization-based security (VBS) and certain kernel-mode drivers or applications.

> [WARNING]
> **Disabling VBS-related protections reduces Windows security.** VBS and Memory Integrity (HVCI) help protect the Windows kernel from malware and exploitation. Only use this script if you know what you're doing, or are aware of the trade-offs.

## Why this exists

Some low-level software—such as certain kernel-mode drivers, system utilities, or gaming-related components—may not work correctly with every Windows security configuration. VBS and related protections use virtualization and code-integrity checks to isolate security functions and restrict certain kernel operations. If a particular driver or application is incompatible, these protections can be one possible cause.

This project is intended as a convenience wrapper for people troubleshooting those compatibility issues. It is **not** a recommendation to disable Windows security features on every system, and disabling VBS is not guaranteed to fix a given application or driver.

For background, see Microsoft's documentation on [Memory Integrity and VBS](https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity) and [driver compatibility with Memory Integrity](https://learn.microsoft.com/en-us/windows-hardware/test/hlk/testref/driver-compatibility-with-device-guard).

## What the script does

When you run the batch file, it:

1. Requests administrator privileges if it is not already running elevated.
2. Checks for `DG_Readiness_Tool_v3.6.ps1` in the `dgreadiness_v3.6` folder beside the batch file.
3. If the PowerShell tool is not present, downloads the ZIP from Microsoft's download server and saves it beside the batch file.
4. Extracts the ZIP into the `dgreadiness_v3.6` subfolder.
5. Runs the Microsoft PowerShell script with the `-Disable` option.
6. Tells you to restart Windows so you can confirm the resulting configuration.

The downloaded ZIP is retained in the root folder. Once the PowerShell tool is present, later runs skip the download and extraction step.

## How to use

1. Save the `.bat` file in a folder where you want the downloaded ZIP and extracted tool to live.
2. Run the batch file and approve the Windows UAC administrator prompt.
3. Follow any instructions displayed by the Microsoft tool.
4. Restart Windows when prompted or after the tool finishes, and confirm the changes during system boot.

## Files created

After running the script, your folder should look like:

```text
Root/
├── DisableVBS.bat
├── dgreadiness_v3.6.zip
└── dgreadiness_v3.6/
    └── DG_Readiness_Tool_v3.6.ps1
```

## Ensure VBS is disabled

After restarting, open **System Information** (`msinfo32`) and review the **Virtualization-based security** status fields. You can also check **Windows Security → Device security → Core isolation details** for Memory Integrity -- we also disable this in other instances alongside Windows Driver Blocklist.

VBS, Credential Guard, Driver Blocklist, and Memory Integrity/HVCI are very stubborn and you'll at times find that Hyper-V cannot be disabled due to a lot of these features which messes with Virtualization and other kernel level procedures. If you for some reason are still unable to find a solution, check my other repositories or contact me.

## Consider before use

- Lowering kernel-level protections can increase exposure to malicious drivers, kernel exploits, and other threats.
- On some devices, such as laptops: this is sometimes troublesome to disable, although not impossible.
- Altering cryptographic measurements stored in the TPM sometimes triggers BitLocker recovery mode - so be prepared to use the recovery key.
