[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\olster.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons



function runScript{
   .\compile.bat
}

function token{
  bat  C:\Users\olste\OneDrive\Escritorio\Development\git_tokens.txt
}

function prettyLog{
  git log --oneline --decorate --graph --all
}

function openExplorer{
  explorer .
}

function copyDir{
  Get-ChildItem -Recurse | Set-Clipboard
}




Set-Alias neo nvim
Set-Alias lg lazygit
Set-Alias oe openExplorer 
Set-Alias qw runScript 
Set-Alias .. cd..
Set-Alias la clear 
Set-Alias ll ls 
Set-Alias tk token
Set-Alias log prettyLog
Set-Alias g git 
Set-Alias xclip copyDir
$VIMEXEPATH    = "c:\<location>\vim.exe"

Set-Alias vim  $VIMEXEPATH
Set-Alias vi   $VIMEXEPATH

Set-PSReadlineOption -EditMode vi

