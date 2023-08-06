import httpclient
import json
import strformat
const API_VERSION* = "2022-11-28"

type
  AsyncGithubClient* = ref object
    apiVersion*: string
    hc*: AsyncHttpClient
  GithubClient* = ref object
    apiVersion*: string
    hc*: HttpClient

  GithubError* = object of Defect
    responseCode*: HttpCode


func newGithubError*(respCode: HttpCode): ref GithubError =
  result = newException(GithubError, "")
  result.responseCode = respCode


template castError*(res: Response or AsyncResponse) =
  if not res.code.is2xx:
    raise newGitHubError(res.code)



proc makeUrl*(endpoint: string): string =
  result = fmt"https://api.github.com{endpoint}"
  when defined(debug):
    echo result



proc newAsyncGithub*(token: string, version: string): AsyncGithubClient =
  var client = AsyncGithubClient(apiVersion: version)
  var hclient = newAsyncHttpClient()
  hclient.headers = newHttpHeaders({ "Authorization": fmt"Bearer {token}" })
  client.hc = hclient
  result = client
proc newGithub*(token, version: string): GithubClient =
  var client = GithubClient(apiVersion: version)
  var hclient = newHttpClient()
  hclient.headers = newHttpHeaders({ "Authorization": fmt"Bearer {token}" })
  client.hc = hclient
  result = client
