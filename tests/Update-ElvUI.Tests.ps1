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

Describe 'Update-ElvUI' {
    It 'Should be available' {
        Get-Command Update-ElvUI -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }
    It 'Should have WoWPath parameter' {
        (Get-Command Update-ElvUI).Parameters.ContainsKey('WoWPath') | Should -BeTrue
    }
    It 'Should have Flavor parameter' {
        (Get-Command Update-ElvUI).Parameters.ContainsKey('Flavor') | Should -BeTrue
    }
    It 'Should have Force parameter' {
        (Get-Command Update-ElvUI).Parameters.ContainsKey('Force') | Should -BeTrue
    }
}
