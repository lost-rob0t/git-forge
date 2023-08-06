import httpclient, client, json, asyncdispatch
import jsony
import strformat
proc setEmailVisibility*(client: AsyncGithubClient or GithubClient, visibility: string): Future[JsonNode] {.multisync.} =
  ## Sets the visibility for your primary email addresses.
  ## Must be public or private
  ## https://docs.github.com/en/rest/users/emails?apiVersion=2022-11-28#list-email-addresses-for-the-authenticated-user
  let q = %* {"visibility": visibility}
  let url = makeUrl("/user/email/visibility")
  let req = await client.hc.patch(url, body=q.toJson)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc listEmails*(client: AsyncGithubClient or GithubClient, perPage=30, page=1): Future[JsonNode] {.multisync.} =
  ## List The current users emails
  ## https://docs.github.com/en/rest/users/emails?apiVersion=2022-11-28#list-email-addresses-for-the-authenticated-user
  let url = makeUrl(fmt"/user/emails?per_page={perPage}&page={page}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc addEmail*(client: AsyncGithubClient or GithubClient, email: string): Future[JsonNode] {.multisync} =
  ## Add an Email to the Account
  ## https://docs.github.com/en/rest/users/emails?apiVersion=2022-11-28#add-an-email-address-for-the-authenticated-user
  let q = @[email].toJson
  let url = makeUrl("/user/emails")
  let req = await client.hc.post(url, body=q)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc addEmails*(client: AsyncGithubClient or GithubClient, emails: seq[string]): Future[JsonNode] {.multisync.} =
  ## Add multiple Emails to the Account
  ## https://docs.github.com/en/rest/users/emails?apiVersion=2022-11-28#add-an-email-address-for-the-authenticated-user
  let q = emails.toJson
  let url = makeUrl("/user/emails")
  let req = await client.hc.post(url, body=q)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson

proc listPublicEmails*(client: AsyncGithubClient or GithubClient, perPage=30, page=1): Future[JsonNode] {.multisync.} =
  let url = makeUrl("/user/public_emails?per_page={perPage}&page={page}")
  let req = await client.hc.get(url)
  when defined(debug):
    echo req.status
  castError req
  result = (await req.body).parseJson
