Configuration xBaLabServerCfg {
    [CmdletBinding()]

    Param (
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    $groups = @('Remote Desktop Users', 'Hyper-V Administrators')
    $features = @('Hyper-V', 'Hyper-V-Powershell')

    Node localhost {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
        }

        xUser 'CreateUserAccount' {
            Ensure = 'Present'
            UserName = Split-Path -Path $Credential.UserName -Leaf
            Password = $Credential
            FullName = 'Baltic Apprentice'
            Description = 'Baltic Apprentice'
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
            PasswordChangeNotAllowed = $true
        }

        xGroup 'SetMembers'
        {
            GroupName = $groups
            Ensure = 'Present'
            MembersToInclude = 'Apprentice'
            DependsOn = '[User]Apprentice'
        }

        xWindowsFeatureSet 'AddFeatures'
        {
            Name = $features
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }
    }
    
}