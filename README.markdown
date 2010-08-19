#Rankstar

Use this gem to calculate the keyword ranking for *Bing*, *Yahoo* or *Google* as follows:

Rankstar.rank(engine, keyword, url) #=> 1

## Arguments:

* engine: Any of the following values: [:google, :bing, :yahoo]
* keyword: The keyword to rank
* url: The site to look for

## Returns:

An integer with the rank of the site. If the site is not within the specified limit, it returns *nil*.

## Limit:

By default, it will only look on the first 100 results. You can enter a higher value by using the :limit option.

Example:

Rankstar.rank(engine, keyword, url, :limit => 200) #=> 123


