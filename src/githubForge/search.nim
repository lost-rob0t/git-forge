import httpclient, client, json, asyncdispatch
import jsony
import strformat
import uri
## Please Note a few things about Github search
## You cannot do the following:
## queries longer than 256 characters (not including operators or qualifiers).
## queries have more than five AND, OR, or NOT operators.
## Github search has its own ratelimting, around 30 req/min
## The api will pull up to 4,000 repos that match

# TODO Include Text match metadata
# sends the numeric offsets of where the matched term
proc searchCode*(client: AsyncGithubClient or GithubClient, query: string sort="indexed",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Search code
  ## Maximum 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code
  let url = encodeUrl(makeUrl(fmt"/search/code?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson

proc searchCommits*(client: AsyncGithubClient or GithubClient, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Find Commits
  ## Maximum 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-commits
  let url = encodeUrl(makeUrl(fmt"/search/commits?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson

proc searchIssues*(client: AsyncGithubClient or GithubClient, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Search For Issues
  ## Maximum of 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-issues-and-pull-requests
  let url = encodeUrl(makeUrl(fmt"/search/issues?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson


proc searchLabels*(client: AsyncGithubClient or GithubClient, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Find Labels in a repo
  ## Maximum of 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-labels
  let url = encodeUrl(makeUrl(fmt"/search/labels?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson


proc searchRepos*(client: AsyncGithubClient or GithubClient, repoId: int, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Search For repositories
  ## Maximum of 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-repositories
  let url = encodeUrl(makeUrl(fmt"/search/repositories?repository_id={repoId}&q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson



proc searchTopics*(client: AsyncGithubClient or GithubClient, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Search topics
  ## Maximum of 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-topics
  let url = encodeUrl(makeUrl(fmt"/search/topics?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson


proc searchUsers*(client: AsyncGithubClient or GithubClient, query: string sort="",
                 order="desc", page=1, perPage=30): Future[JsonNode] {.multisync.} =
  ## Find Users
  ## Maximum of 100 results per page
  ## https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-users

  let url = encodeUrl(makeUrl(fmt"/search/users?q={query}&order={order}&sort={sort}&per_page={perPage}&page={page}"))
  let req = client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req

  result = (await req.body).parseJson
