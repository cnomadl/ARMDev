Configuration xBaLabServerWinCfg {
    [CmdletBinding()]

    Param (
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    $features = @("Hyper-V", "RSAT-Hyper-V-Tools", "Hyper-V-Tools", "Hyper-V-PowerShell")

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

        xGroup "AddRemoteDesktopUserGroup"
        {
            GroupName = "Remote Desktop Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        xGroup "AddHyperVAdministratorGroup"
        {
            GroupName = "Hyper-V Administrators"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        xGroup "AddToUsersGroup"
        {
            GroupName = "Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        xWindowsFeatureSet "AddHyperVFeatures"
        {
            Name = $features
            Ensure = "Present"
            IncludeAllSubFeature = $true
        }
    }
    
}

Configuration xBaTestClientCfg {
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

        xGroup "AddRemoteDesktopUserGroup"
        {
            GroupName = "Remote Desktop Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        xGroup "AddToUsersGroup"
        {
            GroupName = "Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }
    }
}