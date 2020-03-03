Configuration xBaLabServerCfg {
    [CmdletBinding()]

    Param (
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    Node localhost {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
        }

        xUser "CreateUserAccount" {
            Ensure = "Present"
            UserName = Split-Path -Path $Credential.UserName -Leaf
            Password = $Credential
            FullName = "Baltic Apprentice"
            Description = "Baltic Apprentice"
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
            PasswordChangeNotAllowed = $true
        }

        xGroup "AddRemoteDesktopUser"
        {
            GroupName = "Remote Desktop Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]Apprentice"
        }

        xGroup "AddHyperVAdministrator"
        {
            GroupName = "Hyper-V Administrators"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]Apprentice"
        }

        xWindowsFeature "AddFeature"
        {
            Name = "Hyper-V"
            Ensure = "Present"
            IncludeAllSubFeature = $true
        }
    }
    
}