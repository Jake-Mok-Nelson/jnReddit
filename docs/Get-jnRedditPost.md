---
external help file: jnReddit-help.xml
Module Name: jnReddit
online version: 
schema: 2.0.0
---

# Get-jnRedditPost

## SYNOPSIS
Get posts from Reddit

## SYNTAX

```
Get-jnRedditPost [-Name] <String> [[-Sort] <String>] [[-Uri] <String>] [[-MaxResults] <Int32>]
```

## DESCRIPTION
Get posts from Reddit

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-jnRedditPost sysadmin
```

# Gets posts from reddit.com/r/sysadmin in JSON format

### -------------------------- EXAMPLE 2 --------------------------
```
Get-jnRedditPost -Subreddit sysadmin -Sort New -MaxResults 5
```

# Get Redit posts...
#    From /r/sysadmin...
#    Sorted by new posts...
#    Maximum of five items...

### -------------------------- EXAMPLE 3 --------------------------
```
$subreddits = "sysadmin", "devops"; $subreddits | Get-jnRedditPost -Sort New -MaxResults 20
```

# Iterates each of the subreddits in the array...
#    Sorted by new posts...
#    Maximum items returns is 20...

### -------------------------- EXAMPLE 4 --------------------------
```
Get-jnRedditPost -Name SomeUserName -QueryType User -MaxResults 4 -Verbose
```

# Finds posts authored by the specified name
#    Returns only four items...
#    Outputs verbose information...

## PARAMETERS

### -Name
Subreddit name

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Sort
Sorting method:
    Hot
    New
    Rising
    Controversial
    Top

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: Top
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
Uri to query, queries https://api.reddit.com by default

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Https://api.reddit.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxResults
Maximum number of items to return.
Defaults to 25

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 25
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


