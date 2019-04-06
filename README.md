# git-starred-list
List the most starred Github repos that were created in the last 30 days

A swift app that will list the most starred Github repos that were created in the last 30 days.
Results are fetched as JSON from the Github API using the following link:
https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc

The JSON data from Github will be paginated (each page contains certain number of repositories).

To get the 2nd page, you add &page=2 to the end of your API request :

https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc&page=2

To get the 3rd page, you add &page=3 ... etc

Technologies:
xcode 10.1
swift 4.2

Design patterns include:
1-MVC
2-Singelton
3-Facade

No external libraries used.

Advanced:
Implemented prefetching of avatars and pagination of results, the user can continue scrolling and more results will appear.
Avatars will show a loading indicator if not fetched yet.

Mohammad Dawi
April 6,2019

