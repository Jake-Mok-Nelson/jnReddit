Function Get-jnRedditPost {
    <#
    .SYNOPSIS
        Get posts from Reddit

    .DESCRIPTION
        Get posts from Reddit

    .PARAMETER Name
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
    
    .PARAMETER Filter
    Response format:
        TextPost
        ImagePost
        Any

    .EXAMPLE
        Get-jnRedditPost sysadmin

        # Gets posts from reddit.com/r/sysadmin in JSON format

    .EXAMPLE
        Get-jnRedditPost -Subreddit sysadmin -Sort New -MaxResults 5

        # Get Redit posts...
        #    From /r/sysadmin...
        #    Sorted by new posts...
        #    Maximum of five items...

    .EXAMPLE
        $subreddits = "sysadmin", "devops"; $subreddits | Get-jnRedditPost -Sort New -MaxResults 20

        # Iterates each of the subreddits in the array...
        #    Sorted by new posts...
        #    Maximum items returns is 20...

        .EXAMPLE
        Get-jnRedditPost -Name SomeUserName -QueryType User -MaxResults 4 -Verbose

        # Finds posts authored by the specified name
        #    Returns only four items...
        #    Outputs verbose information...

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
            HelpMessage = "What is the subreddit or user you would like to query?"
        )]
        [ValidateCount(1,22)]
        [string]$Name,
        
        [ValidateSet('Top', 'New')]
        [string]$Sort = 'Top',
        
        [string]$Uri = 'https://api.reddit.com',

        # 25 is the default recommended by Reddit, max is 100.
        [ValidateRange(1,100)] 
        [int]$MaxResults = 25

    )

    # this holds our Post instances before returning the object
    $postsReturn = @()

    # we don't want weird uppercase letters in our URLs
    $Sort = $Sort.ToLower()

    ForEach($itm in $Name){
    
        $subRedditUri = $Uri + '/r/' + $itm + "/$Sort.json?limit=$maxResults"

        Try{
            
            Write-Verbose -Message "Querying Reddit with Uri: $subRedditUri"
            $jsonResponse = Invoke-WebRequest -Uri $subRedditUri -Method GET
            Write-Verbose -Message "HTTP Response: $($jsonResponse.StatusCode)"
            
            if ($jsonResponse.StatusCode -eq 200){

                try {

                    Write-verbose "converting the resulting JSON to a PowerShell Object"
                    $objResponse = $jsonResponse.Content | ConvertFrom-Json
                    $objPosts = $objResponse.data.children
                    
                    Write-verbose -message "Iterating posts"
                    $count = 0

                    Foreach ($post in $objPosts) {

                        $count++
                        Write-Verbose -Message "Post: $count"

                        # temporary storage for the converted object
                        $currentPost = $post.data
                        Write-verbose -Message "Found a post: $currentPost"

                        # a new instance of our Post class
                        $postClass = New-Object Post

                        $postClass.subreddit = $currentPost.Subreddit
                        $postClass.url = $currentPost.url
                        $postClass.author = $currentPost.author
                        $postClass.id = $currentPost.id
                        $postClass.content = $currentPost.content
                        $postClass.title = $currentPost.title
                        $postClass.thumbnail = $currentPost.thumbnail
                        $postClass.permalink = $currentPost.permalink
                        $postClass.createdUTC = $currentPost.created_utc
                        $postClass.numComments = $currentPost.num_comments
                        
                        # image check
                        if (!($currentPost.url | Test-jnRedditImage)) {
                            
                            # not an image
                            $postClass.isImage = $false
                        } 
                        elseif ($currentPost.url | Test-jnRedditImage) {
                            
                            #is an image
                            $postClass.isImage = $True
                        }
                        else {

                            #it's probably not an image
                            $postClass.isImage = $false
                        }

                        # store the result in an array for output
                        $postsReturn += $postClass

                    } # end foreach post

                } catch {

                    # can't convert the json to an object or the data is invalid
                    Throw $_
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


    #write the output as an object      
    Write-Output $postsReturn

} # end function