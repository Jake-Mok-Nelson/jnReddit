Function Get-jnRedditPost {
    <#
    .SYNOPSIS
        Get posts from Reddit

    .DESCRIPTION
        Get posts from Reddit

    .PARAMETER Subreddit
        Subreddit name

    .PARAMETER Sort
        Sorting method:
            Hot
            New
            Rising
            Controversial
            Top

    .PARAMETER Uri
        Uri to query, queries https://api.reddit.com by default

    .PARAMETER MaxResults
        Maximum number of items to return. Defaults to 25

    .PARAMETER ResponseFormat
        Response format:
            JSON
            Object

    .EXAMPLE
        Get-jnRedditPost sysadmin

        # Gets posts from reddit.com/r/sysadmin in JSON format

    .EXAMPLE
        Get-jnRedditPost -Subreddit sysadmin -Sort New -MaxResults 5

        # Get Redit posts...
        #    From /r/sysadmin...
        #    Sorted by new posts...
        #    Maximum of five items...
        #    JSON format...

    .EXAMPLE
        $subreddits = "sysadmin", "devops"; $subreddits | Get-jnRedditPost -Sort New -MaxResults 20

        # Iterates each of the subreddits in the array...
        #    Sorted by new posts...
        #    Maximum items returns is 20...
        #    JSON format...

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
            HelpMessage = "What is the subreddit you would like to query?"
        )]
        [ValidateCount(1,22)]
        [string]$Subreddit,
        
        [ValidateSet('Hot', 'New', 'Rising', 'Controversial', 'Top')]
        [string]$Sort = 'New',
        
        [string]$Uri = 'https://api.reddit.com',

        [int]$MaxResults = 25,

        [ValidateSet('JSON', 'Object')]
        [string]$ResponseFormat = "JSON"
    )

    # this holds our results before returning the object in the event
    # that the response format 'Object' was selected
    $postsReturn = @()

    $Sort = $Sort.ToLower()

    ForEach($sub in $Subreddit){
        $subRedditUri = $Uri + "/r/$sub/$Sort.json?sort=new?count=$maxResults"

        Try{
            Write-Verbose -Message "Querying Reddit with Uri: $subRedditUri"
            $jsonResponse = Invoke-WebRequest -Uri $subRedditUri -Method GET
            Write-Verbose -Message "HTTP Response: $($jsonResponse.StatusCode)"
            
            if ($jsonResponse.StatusCode -eq 200){

                if ($ResponseFormat -contains "JSON") {

                    Write-Verbose -Message "Returning result as JSON:"
                    try {
    
                        Write-Output $jsonResponse.Content
                    }
                    Catch {
    
                        # error returning object, the .content probably doesn't exist
                        Throw $_
                    }

                } elseif ($ResponseFormat -contains "Object") {
                    Write-Verbose -Message "Returning result as a PowerShell Object:"

                    try {

                        # converting the resulting JSON to a PowerShell Object
                        $objResponse = $jsonResponse.Content | ConvertFrom-Json
                        $objPosts = $objResponse.data.children
                        
                        Foreach ($post in $objPosts) {

                            #iterate the posts
                            $currentPost = $post.data
                            $props = @{
                                'subreddit' = $currentPost.subreddit;
                                'url' = $currentPost.url;
                                'author' = $currentPost.author;
                                'id' = $currentPost.id;
                                'content' = $currentPost.selftext;
                                'title' = $currentPost.title;
                            }

                            $tempObj = New-Object -TypeName PSObject -Property $props
                            $postsReturn += $tempObj
                            Write-verbose -message "Created a post object $tempObj"
                        }

                    } catch {

                        # can't convert the json to an object or the data is invalid
                        Throw $_
                    }
                }         

            } else {

                # http error
                throw "HTTP error. Status: `n$($jsonResponse.StatusCode + "`n" + $jsonResponse.StatusDescription)"
            }
        }
        Catch {

            # error invoking the web request, probably an invalid url or the server is unreachable
            Throw $_
        }
    } # end foreach

    if ($ResponseFormat -contains "Object") {

        #write the output as an object      
        Write-Output $postsReturn
    }

} # end function