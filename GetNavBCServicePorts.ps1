# Powershell Script to easily find ports of installed Navision/Business Central Instances on a given server
Get-ChildItem "C:\Program Files\Microsoft Dynamics*\" -Recurse -Filter "CustomSettings.config" |
ForEach-Object {
    [xml]$config = Get-Content $_.FullName
    $instanceName = (Split-Path $_.DirectoryName -Leaf)

    # Create a lookup table for all <add key=... value=...>
    $settings = @{}
    foreach ($add in $config.appSettings.add) {
        $settings[$add.key] = $add.value
    }

    [PSCustomObject]@{
        Instance   = $instanceName
        MgmtPort   = $settings["ManagementServicesPort"]
        ClientPort = $settings["ClientServicesPort"]
        SOAPPort   = $settings["SOAPServicesPort"]
        ODataPort  = $settings["ODataServicesPort"]
        DevPort    = $settings["DeveloperServicesPort"]
        Database   = $settings["DatabaseName"]
        Server     = $settings["DatabaseServer"]
    }
} |ogv
