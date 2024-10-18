import isNil from "lodash/isNil"
import isString from "lodash/isString"
import get from "lodash/get"
import urlJoin from "url-join"
import superagent from "superagent"

const directusUrl = process.env.PUBLIC_URL
const accessToken = process.env.ADMIN_TOKEN
const json = "json"

export def post pathname, body, done
	const url = urlJoin directusUrl, pathname
	superagent.post(url)
		.accept(json)
		.type(json)
		.set("Authorization", "Bearer {accessToken}")
		.send(body)
		.end(done)

export def download pathname, done
	const url = urlJoin directusUrl, pathname
	superagent.get(url)
		.query({ access_token: accessToken })
		.accept(json)
		.end(done)

export def printHttpError err
	const { status, message, response } = err
	console.error status, message
	if not isNil(response)
		const { body, text } = response
		console.error "body", body
		console.error "text", text

export def alreadyExists err
	const message = get err, "response.body.errors.0.message"
	isString(message) and (message.includes("already exists") or message.includes("has to be unique"))
