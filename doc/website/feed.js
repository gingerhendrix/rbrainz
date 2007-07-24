google.load('feeds', '1');

function getYearString(dateString) {
    var date = new Date(dateString);
    var result = date.getFullYear() + '-';
    if (date.getMonth() < 10)
        result += '0';
    result += date.getMonth() + '-';
    if (date.getDate() < 10)
        result += '0';
    result += date.getDate();
    
    return result;
}

function load_news() {
    var feed = new google.feeds.Feed('http://rubyforge.org/export/rss_sfnews.php?group_id=3677');
    feed.load(function(result) {
        if (!result.error) {
            var container = document.getElementById('news');
            for (var i = 0; i < 3; i++) {
                var entry = result.feed.entries[i];
                
                var div = document.createElement('div');
                
                var headline = document.createElement('h4');
                var title = document.createTextNode(entry.title.substring(35));
                var link = document.createElement('a');
                var href = document.createAttribute('href');
                href.nodeValue = entry.link;
                link.setAttributeNode(href);
                link.appendChild(title);
                headline.appendChild(link);
                div.appendChild(headline);
                
                var dateContainer = document.createElement('span');
                var dateClass = document.createAttribute('class');
                dateClass.nodeValue = 'date';
                dateContainer.setAttributeNode(dateClass);
                var date = document.createTextNode(getYearString(entry.publishedDate) + ' ');
                dateContainer.appendChild(date);
                
                var snippet = document.createTextNode(entry.contentSnippet);
                div.appendChild(dateContainer);
                div.appendChild(snippet);
                
                container.appendChild(div);
            }
        }
    });
}
google.setOnLoadCallback(load_news);