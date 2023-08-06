import client
import strformat
import json
proc getRepoClones*(client: AsyncGithubClient or GithubClient, owner, repo: string): Future[JsonNode] {.multisync.} =
  ## https://docs.github.com/en/rest/metrics/traffic?apiVersion=2022-11-28#get-repository-clones
  let url = makeUrl(fmt"/repos/{owner}/{repo}/traffic/clones")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson


proc getTopRefPaths*(client: AsyncGithubClient or GithubClient): Future[JsonNode] {.multisync.} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}/traffic/popular/paths")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson
