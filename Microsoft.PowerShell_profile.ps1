# custom functions
function wga {
	$command = "winget update --all"
	Write-Output $command
	Invoke-Expression $command
}
    function conssh {
        $command = "explorer $env:USERPROFILE\.ssh"
        Write-Output $command
        Invoke-Expression $command
    }
    
    function copyssh {
        <#
        .SYNOPSIS
        Kopiert den SSH Public Key auf einen Remote-Server.
        .DESCRIPTION
        Diese Funktion kopiert den Public Key aus dem lokalen `.ssh`-Ordner in die `authorized_keys`-Datei eines Remote-Servers.
        .PARAMETER user
        Der Benutzername für die SSH-Verbindung.
        .PARAMETER ip
        Die IP-Adresse des Remote-Servers.
        .EXAMPLE
        copyssh -user username -ip 192.168.1.1
        Kopiert den Public Key zu `username@192.168.1.1`.
        .NOTES
        Stellen Sie sicher, dass der SSH-Dienst auf dem Zielserver aktiv ist.
        #>
            param (
                [Parameter(Mandatory=$true, HelpMessage="Geben Sie den Benutzernamen an.")]
                [string]$user,
        
                [Parameter(Mandatory=$true, HelpMessage="Geben Sie die IP-Adresse des Remote-Servers an.")]
                [string]$ip
            )
            $command = "Get-Content `"$env:USERPROFILE\.ssh\id_rsa.pub`" | ssh $user@$ip 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'"
            Write-Output $command
            Invoke-Expression $command
        }

    function posh {

	$command = "oh-my-posh upgrade"
	Write-Output $command
	Invoke-Expression $command
}

function Invoke-AdminShell {
	Invoke-Expression gsudo
}

function Invoke-LastCommandAsAdmin {
    # Hole den letzten Befehl aus der Historie
    $lastCommand = (Get-History | Select-Object -Last 1).CommandLine
    
    # Starte eine neue PowerShell-Sitzung mit Admin-Rechten und führe den letzten Befehl aus
    gsudo $lastCommand
}

# design
oh-my-posh init pwsh --config "C:\Users\BartholomaiK\AppData\Local\Programs\oh-my-posh\themes\montys.omp.json" | Invoke-Expression
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# features
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
