import httpclient, client, json, asyncdispatch
import jsony
import strformat

proc listOrgRepos*(client: AsyncGithubClient or GithubClient, org: string,
                   sort="created", direction="asc", `type`="public", perPage = 30, page = 1): Future[JsonNode] {.multisync.} =

  let url = makeUrl(fmt"/orgs/{org}/repos?sort={sort}&direction={direction}&type={`type`}&per_page={perPage}&page={page}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc createOrgRepo*(client: AsyncGithubClient or GithubClient, org, name: string, options: JsonNode): Future[JsonNode] {.multisync.} =
    ## https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-an-organization-repository
    # HACK Find a better method?
    # TODO Remove this, the user should give a json object, this is nuts

    let url = makeUrl(fmt"/orgs/{org}/repos")
    let req = await client.hc.post(url, body=options.toJson)
    when defined(debug):
      echo req.status
    castError req
    result = (await req.body).parseJson

proc getRepo*(client: AsyncGithubClient or GithubClient, repo, owner: string): Future[JsonNode] {.multisync.} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc updateRepo*(client: AsyncGithubClient or GithubClient, owner, repo: string, options: JsonNode): Future[JsonNode] {.multisync} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}")
  let req = await client.hc.patch(url, body=options.toJson)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc deleteRepo*(client: AsyncGithubClient or GithubClient, owner, repo: string)  {.multisync.} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}")
  let req = await client.hc.delete(url)
  when defined(debug):
    echo req.status
  castError req

proc enableRepoSecurity*(client: AsyncGithubClient or GithubClient, owner, repo: string) {.multisync.} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}/automated-security-fixes")
  let req = await client.hc.put(url)
  when defined(debug):
    echo req.status
  castError req

proc disableRepoSecurity*(client: AsyncGithubClient or GithubClient, owner, repo: string) {.multisync.} =
  let url = makeUrl(fmt"/repos/{owner}/{repo}/automated-security-fixes")
  let req = await client.hc.delete(url)
  when defined(debug):
    echo req.status
  castError req
