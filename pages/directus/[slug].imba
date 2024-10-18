###

An example how you might display different types of content servcd out of
directus. It requests via the API then displays as AST, HTML, or text.

Compare this with the edit pages screen and directus.

Edit

+ pathname
+ title
+ blocks = editor.js AST
+ code
+ text
+ wysiwyg
+ markdown

###

import isNil from "lodash/isNil"
import get from "lodash/get"
import urlJoin from "url-join"
import { hasContent } from "../../lib/strings"
import { getPage } from "../_directus"

const blankArticle = {
	pathname: ""
	title: ""
	blocks: null
	code: null
	text: null
	wysiwyg: null
	markdown: null
	icon: null
}

export default tag DirectusPage
	prop locals = {}
	static def GET req, res, next
		const { slug } = req.params
		const pathname = urlJoin "/directus", slug
		const apiRes = await getPage pathname
		let article = get apiRes, "body.data.0"
		if isNil(article) and apiRes.text.startsWith('\{"data":')
			# there's an odd case where it wont parse the response so we do it
			const apiText = try JSON.parse apiRes.text
			article = get apiText, "data.0"
		res.locals.article = article
		next!
	get article
		get(locals, "article", blankArticle)
	<self>
		<h1> article.title
		if not isNil(article.blocks)
			<div>
				<div> "TODO: render editor.js blocks"
				<div> "article.blocks: {JSON.stringify(article.blocks)}"
		elif hasContent(article.code)
			<div innerHTML=article.code>
		elif hasContent(article.text)
			<pre><code> article.text
		elif hasContent(article.wysiwyg)
			<div innerHTML=article.wysiwyg>
		elif hasContent(article.markdown)
			<pre><code> article.markdown
