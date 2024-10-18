###

A simple proxy that the client side can request from at `/api` path. It allows
the client to request from directus through `GET /api?pathname=/xyz`.

###

import { isNode } from "../lib/environment"
import { getPage } from "./_directus"

export default tag ApiProxy
	static def GET req, res, next
		if not isNode then next!
		const { pathname } = req.query
		getPage(pathname).pipe(res)
	<self>
		<div> "ApiProxy"