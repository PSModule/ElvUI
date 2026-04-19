[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSReviewUnusedParameter', '',
    Justification = 'Required for Pester tests'
)]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Required for Pester tests'
)]
[CmdletBinding()]
param()

Describe 'Install-ElvUI' {
    It 'Should be available' {
        Get-Command Install-ElvUI -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }
    It 'Should have WoWPath parameter' {
        (Get-Command Install-ElvUI).Parameters.ContainsKey('WoWPath') | Should -BeTrue
    }
    It 'Should have Flavor parameter' {
        (Get-Command Install-ElvUI).Parameters.ContainsKey('Flavor') | Should -BeTrue
    }
}
