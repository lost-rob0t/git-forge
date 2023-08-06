import httpclient, client, json, asyncdispatch
import jsony
import strformat

proc getCurrentUser*(client: AsyncGithubClient or GithubClient): Future[JsonNode] {.multisync.} =
  ## Get The Current Authenticated User
  ## https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user
  let url = makeUrl("/user")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson


proc updateCurrentUser*(client: AsyncGithubClient or GithubClient, options: JsonNode): Future[JsonNode] {.multisync} =
  ## Update The current user's settings
  ## https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#update-the-authenticated-user
  let url = makeUrl("/user")
  let req = await client.hc.patch(url, body=options.toJson)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc listUsers*(client: AsyncGithubClient or GithubClient, since, perPage: int): Future[JsonNode] {.multisync.} =
  ## List All Users in the order in wich they joined Github
  ## This Is probably The most Abusable endpoint from an OSINT view
  ## https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#list-users
  let url = makeUrl(fmt"/users?since={since}&per_page={perPage}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson


proc getUser*(client: AsyncGithubClient or GithubClient, username: string): Future[JsonNode] {.multisync.} =
  ## Get Public information about a user.
  ## https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-a-user
  let url = makeUrl(fmt"/users/{username}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc listBlockedUsers*(client: AsyncGithubClient or GithubClient, perPage=30, page=1): Future[JsonNode] {.multisync.} =
  ## Get a list of blocked Users from the current user
  ## https://docs.github.com/en/rest/users/blocking?apiVersion=2022-11-28#list-users-blocked-by-the-authenticated-user
  let url = makeUrl(fmt"/user/blocks?per_page={perPage}&page={page}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc checkBlockStatus*(client: AsyncGithubClient or GithubClient, username: string): Future[bool] {.multisync.} =
  let url = makeUrl(fmt"/user/blocks/{username}")
  let req = await client.hc.get(url)
  let code = req.code
  when defined(debug):
    echo req.status
  if code != Http204:
    result = false
  else:
    result = true

proc blockUser*(client: AsyncGithubClient or GithubClient, username: string) {.multisync.} =
  let url = makeUrl(fmt"/user/blocks/{username}")
  let req = await client.hc.put(url)
  when defined(debug):
    echo req.status
  castError req

proc unblockUser*(client: AsyncGithubClient or GithubClient, username: string) {.multisync.} =
  let url = makeUrl(fmt"/user/blocks/{username}")
  let req = await client.hc.delete(url)
  when defined(debug):
    echo req.status
  castError req
