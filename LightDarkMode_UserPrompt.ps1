Add-Type -AssemblyName PresentationFramework

$MessageHeaderLM = "We need you to approve this light mode"
$MessageHeaderDM = "We need you to approve this dark mode"
$MessageTextLM = "You've asked for light mode, is this to your liking?. &#10;To resolve this, your approval is needed.. Andrew... &#10;Press *Approved* to continue."
$MessageTextDM = "You've asked for dark mode, is this to your liking?. &#10;To resolve this, your approval is needed.. Andrew... &#10;Press *Approved* to continue."

[XML]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="IntuneWin32 Deployer" 
    Height="200" Width="420"
    WindowStartupLocation="CenterScreen" WindowStyle="None" 
    ShowInTaskbar="False" 
    ResizeMode="NoResize" Background="White" Foreground="Black">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid Grid.Column="1" Margin="10">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Name="TextMessageHeader" Text="$MessageHeaderLM" FontSize="20" VerticalAlignment="Top" HorizontalAlignment="Left"/>
            <TextBlock Name="TextMessageBody" Text="$MessageTextLM" Grid.Row="1" VerticalAlignment="Center" HorizontalAlignment="Left" TextWrapping="Wrap" />
            <StackPanel x:Name="Buttons" Grid.Row="2" Orientation="Horizontal">
                <Button x:Name="ButtonAbort" Content="Abort" Background="#FFDDDDDD" Foreground="Black" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="1" Width="90"/>
                <Button x:Name="ButtonClear" Content="Approved" Background="#FF4CAF50" Foreground="White" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="0" Width="90"/>
            </StackPanel>
            <TextBlock Name="TextTimer" Grid.Row="2" VerticalAlignment="Center" HorizontalAlignment="Right" FontSize="16" Margin="0,0,10,0"/>
        </Grid>
    </Grid>
</Window>
"@

[XML]$xamlDM = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="IntuneWin32 Deployer" 
    Height="200" Width="420"
    WindowStartupLocation="CenterScreen" WindowStyle="None" 
    ShowInTaskbar="False" 
    ResizeMode="NoResize" Background="#FF1B1A19" Foreground="white">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid Grid.Column="1" Margin="10">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Name="TextMessageHeader" Text="$MessageHeaderDM" FontSize="20" VerticalAlignment="Top" HorizontalAlignment="Left"/>
            <TextBlock Name="TextMessageBody" Text="$MessageTextDM" Grid.Row="1" VerticalAlignment="Center" HorizontalAlignment="Left" TextWrapping="Wrap" />
            <StackPanel x:Name="Buttons" Grid.Row="2" Orientation="Horizontal">
                <Button x:Name="ButtonAbort" Content="Abort" Background="#504c49" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="1" Width="90"/>
                <Button x:Name="ButtonClear" Content="Approved" Background="#46a049" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="0" Width="90"/>
            </StackPanel>
            <TextBlock Name="TextTimer" Grid.Row="2" VerticalAlignment="Center" HorizontalAlignment="Right" FontSize="16" Margin="0,0,10,0"/>
        </Grid>
    </Grid>
</Window>
"@

# Load XAML
# Check system theme
$systemTheme = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' | Select-Object -ExpandProperty 'AppsUseLightTheme'

# Load XAML based on system theme
if ($systemTheme) {
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
} else {
    $reader = (New-Object System.Xml.XmlNodeReader $xamlDM)
}

$Window = [Windows.Markup.XamlReader]::Load($reader)

# Make the window always on top
$Window.Topmost = $true

# Event handler for the "Clear" button
$Window.FindName("ButtonClear").Add_Click({

    $Window.Close()

    Write-Host "Action approved!"
    exit 0
})

# Event handler for the "Abort" button
$Window.FindName("ButtonAbort").Add_Click({

    $Window.Close()

    Write-Host "Action aborted!"
    exit 1

})

# Timer
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(1)
$startTime = Get-Date # Add this line
$timer.Add_Tick({
    $timeLeft = [TimeSpan]::FromHours(1) - (New-TimeSpan -Start $startTime)
    if ($Window -ne $null) {
        $Window.FindName("TextTimer").Text = "Time left: $($timeLeft.ToString('hh\:mm\:ss'))"
    }
})

# Start the timer
$timer.Start()

# Show the window
$Window.ShowDialog() | Out-Null
