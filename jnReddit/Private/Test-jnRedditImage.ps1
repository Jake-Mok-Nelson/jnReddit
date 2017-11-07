Function Test-jnRedditImage {
    <#
    .SYNOPSIS
        Tests a URL to determine of there is an image

    .DESCRIPTION
        Tests a URL to determine of there is an image

    .PARAMETER URL
        The URL to test

    .EXAMPLE
        Test-jnRedditImage -url $url

        # Returns true if the specified url contains an image

    .EXAMPLE
        $someArray | Test-jnRedditImage

        # Queries the piped URL...
        #    Returns true if an image...
        #    Returns false if not...

    .FUNCTIONALITY
        Reddit

    .LINK
        http://

    .LINK
        https://

    #>
    [cmdletbinding()]
    param(
        [parameter(
            ValueFromPipeline = $True,
            Mandatory = $True,
            HelpMessage = "What is the URL you would like to query?"
        )]
        
        
        [string]$URL
    )


    begin{

        $imageExts = ".jpg", ".png", ".gif"   
    }

    process{
        
        # hit will change to true so we can quit the loop early if required
        $hit = $false

        forEach ($ext in $imageExts){

            if ($hit -eq $false){

                if ($URL.subString($URL.length - 4) -contains $ext){
                    
                    #if the extension matches one from the array above, will return true
                    $hit = $true
                }
                else {
                    
                    #if the extension doesn't match one from the array above, will return false
                    $hit = $false
                }
            }
        } # end foreach extension

        #return the result
        $hit

    } # end process
} # end function
