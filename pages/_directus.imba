###

This is a function used by ./api.imba and ./directus/[slug].imba. It requests
to the directus API for a single page queried by it's `pathname`.

###

import urlJoin from "url-join"
import get from "lodash/get"
import { isNode } from "../lib/environment"
import { hasContent } from "../lib/strings"
import superagent from "superagent"

const directusUrl = isNode ? "http://directus:8055/items/pages" : "/api"

export def getPage pathname
	let query
	if isNode
		# server queries directus directly
		const queryJson = JSON.stringify({ pathname: { _eq: pathname } })
		query = "?filter={queryJson}&limit=1"
	else
		# client queries to /api proxy
		query = "?pathname={pathname}"
	superagent.get("{directusUrl}{query}").accept("json")