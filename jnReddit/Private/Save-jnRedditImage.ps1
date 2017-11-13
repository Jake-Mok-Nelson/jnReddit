Function Save-jnRedditImage {
    <#
    .SYNOPSIS
        Downloads an image

    .DESCRIPTION
        Downloads an image to a specified location

    .PARAMETER URL
        The source URL to download

    .PARAMETER Destination
        The destination to save the file. (a directory)

    .EXAMPLE
        Test-jnRedditImage -url $url -destination .\pictures\

        # Returns true if the image was saved

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
            ValueFromPipeline = $False,
            Mandatory = $True,
            HelpMessage = "What is the URL you would like to query?"
        )]
        
        
        [string]$URL,
        
        [parameter(
            Mandatory = $True,
            HelpMessage = "What is the destination you'd like to save the file?"
        )]
        [string]$Destination,
        
        [parameter(
            Mandatory = $False,
            HelpMessage = "Overwrite files and create missing directories."
        )]
        [bool]$Force
    )


    begin {

    }

    process {
        
        # image check
        if ($url | Test-jnRedditImage) {
            
            $imgName = $URL.Split('/'[-1])
            $imgName = $imgName[$imgName.Count -1]
            Write-Verbose "Found an image: $imgName"

            # verify the directory exists
            try {
                if (get-item -Path $Destination -ErrorAction SilentlyContinue) {
                    
                    Write-Verbose "Found Directory at $destination"
                    $destination = $destination + $imgName
                    write-verbose "Destination is now: $destination"

                } else {

                    Write-verbose "Directory doesn't exist"
                    if ($Force){
                             
                        try {

                            Write-Verbose "Attempting to create: $destination"
                            New-item -Path $Destination -Force -ItemType Directory
                        }
                        catch {
    
                            throw "Unable to create destination directory, do you have permission?"
                        }
                    }
                    else {

                        throw "Destination directory doesn't exist."
                    }
                }
            }
            catch {

                throw $_
            }

            # download the image and save it
            try {

                Write-Verbose "Downloading image `n From: $url `n To: $destination"
                Invoke-WebRequest -Uri $URL -OutFile $Destination -ErrorVariable webRequestError
            }
            catch {

                Throw $_
            }         
        } # end if valid image
        else {

            #it's probably not an image
            Throw "Invalid image format"

        }

    } # end process

    end {

        #output the result
        if ($webRequestError){
            
            throw "There was an error with the web request."
        
        } else {

            Write-Verbose "Everything seems good, returning true."
            $true
        }
    }

} # end function
