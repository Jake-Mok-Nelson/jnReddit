# a new instance of this class holds each post as we iterate through them

class Post {

    [string]$subreddit
    [string]$url
    [string]$author
    [string]$id
    [string]$content
    [string]$title
    [string]$thumbnail
    [int]$score
    [string]$permalink
    [string]$createdUTC
    [int]$numComments
    [bool]$isImage

    Open (){

        # opens a web browser to the url in the object
        Start-Process -FilePath $this.url
    }

    Download ($destination){

        # downloads an image to disk
        Save-jnRedditImage -URL $this.url -Destination $destination
    }
}